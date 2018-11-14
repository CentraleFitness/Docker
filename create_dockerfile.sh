#!/bin/sh


# Config env
ENV MAVEN_VERSION=3.3.3 \
    JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=131 \
    JAVA_VERSION_BUILD=11 \
    JAVA_PATH=d54c1d3a095b4ff2b6607d096fa80163 \
    JAVA_PACKAGE=jdk \
    JAVA_JCE=standard \
    JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin \
    GLIBC_VERSION=2.25-r0 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
	PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
	USERNAME=prenom.nom@mail.com \
	PASSWORD=password
	
	# EXTRA
RUN echo "@testing http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN echo "@edge http://dl-3.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "@community http://dl-3.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk update

# Update & install basic
RUN apk upgrade --update && apk add alpine-sdk man man-pages bash-doc bash-completion openssh-client \
	curl htop bash ncurses screen nano tar util-linux pciutils usbutils coreutils binutils findutils \
	grep build-base gcc abuild binutils binutils-doc gcc-doc cmake cmake-doc extra-cmake-modules@testing \
	extra-cmake-modules-doc@testing ccache ccache-doc ca-certificates wget python3 py-pip outils-sha512 \
	emacs git ttf-ubuntu-font-family ttf-droid neovim neovim-doc mdocml-apropos curl-doc 

# JAVA SE & LIB C
RUN for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    mkdir /opt && \
    curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/java.tar.gz \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PATH}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz && \
    gunzip /tmp/java.tar.gz && \
    tar -C /opt -xf /tmp/java.tar && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk && \
    if [ "${JAVA_JCE}" == "unlimited" ]; then echo "Installing Unlimited JCE policy" >&2 && \
      curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip \
        http://download.oracle.com/otn-pub/java/jce/${JAVA_VERSION_MAJOR}/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cd /tmp && unzip /tmp/jce_policy-${JAVA_VERSION_MAJOR}.zip && \
      cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar /opt/jdk/jre/lib/security; \
    fi && \
    sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=30/ $JAVA_HOME/jre/lib/security/java.security && \
    rm -rf /opt/jdk/*src.zip \
           /opt/jdk/lib/missioncontrol \
           /opt/jdk/lib/visualvm \
           /opt/jdk/lib/*javafx* \
           /opt/jdk/jre/plugin \
           /opt/jdk/jre/bin/javaws \
           /opt/jdk/jre/bin/jjs \
           /opt/jdk/jre/bin/orbd \
           /opt/jdk/jre/bin/pack200 \
           /opt/jdk/jre/bin/policytool \
           /opt/jdk/jre/bin/rmid \
           /opt/jdk/jre/bin/rmiregistry \
           /opt/jdk/jre/bin/servertool \
           /opt/jdk/jre/bin/tnameserv \
           /opt/jdk/jre/bin/unpack200 \
           /opt/jdk/jre/lib/javaws.jar \
           /opt/jdk/jre/lib/deploy* \
           /opt/jdk/jre/lib/desktop \
           /opt/jdk/jre/lib/*javafx* \
           /opt/jdk/jre/lib/*jfx* \
           /opt/jdk/jre/lib/amd64/libdecora_sse.so \
           /opt/jdk/jre/lib/amd64/libprism_*.so \
           /opt/jdk/jre/lib/amd64/libfxplugins.so \
           /opt/jdk/jre/lib/amd64/libglass.so \
           /opt/jdk/jre/lib/amd64/libgstreamer-lite.so \
           /opt/jdk/jre/lib/amd64/libjavafx*.so \
           /opt/jdk/jre/lib/amd64/libjfx*.so \
           /opt/jdk/jre/lib/ext/jfxrt.jar \
           /opt/jdk/jre/lib/ext/nashorn.jar \
           /opt/jdk/jre/lib/oblique-fonts \
           /opt/jdk/jre/lib/plugin.jar \
           /tmp/* /var/cache/apk/* && \
    echo "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" >> /etc/nsswitch.conf

# Maven
RUN cd /usr/share \
 && wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - \
 && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# SSH
RUN mkdir /root/.ssh/
RUN touch /root/.ssh/known_hosts && \
	ssh-keyscan gitlab.com >> /root/.ssh/known_hosts && \
	ssh-keyscan github.com >> /root/.ssh/known_hosts && \
	ssh-keyscan git.epitech.eu >> /root/.ssh/known_hosts

# TERM
WORKDIR /
RUN git clone https://github.com/Bash-it/bash-it.git
WORKDIR /bash-it
RUN ./install.sh -s
WORKDIR /tmp_blih
RUN echo "exec >/dev/tty 2>/dev/tty </dev/tty" >> /root/.bashrc
RUN echo "ssh-keygen-coding" >> /root/.bashrc
RUN echo "eval \`ssh-agent\`" >> /root/.bashrc
RUN echo "ssh-add /root/.ssh/id_rsa_coding" >> /root/.bashrc
RUN echo "clear" >> /root/.bashrc

# BLIH
RUN apk update && apk add ca-certificates wget python3 py-pip outils-sha512
RUN wget http://pkg.blinux.fr/pub/blih/1.7/blih-1.7.tgz
RUN tar xzf blih-1.7.tgz
RUN mv blih-1.7/blih.py /usr/bin/blih
COPY res/fix_blih.sh /usr/bin/fix_blih
COPY res/repo.sh /usr/bin/repo
COPY res/ssh-keygen-coding.sh /usr/bin/ssh-keygen-coding
COPY res/create-repo.sh /usr/bin/create-repo
RUN chmod +x /usr/bin/create-repo
RUN chmod +x /usr/bin/ssh-keygen-coding
RUN chmod +x /usr/bin/repo
RUN chmod +x /usr/bin/fix_blih
RUN fix_blih
RUN echo "alias blih=\"blih -u \$USERNAME -t \\\"\$(sha512 -s \$PASSWORD -q)\\\"\"" >> /root/.bashrc
WORKDIR /root/
RUN rm -rf /tmp_blih

# Alias
RUN echo "alias ne=\"emacs\"" >> /root/.bashrc
RUN echo "alias vi=\"nvim\"" >> /root/.bashrc
RUN echo "alias n=\"vi\"" >> /root/.bashrc
RUN echo "alias v=\"vi\"" >> /root/.bashrc
RUN echo "alias i=\"vi\"" >> /root/.bashrc
RUN echo "alias m=\"vi\"" >> /root/.bashrc

RUN apk update

CMD ["/bin/bash", "-i"]