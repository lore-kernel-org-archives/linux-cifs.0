From: Jorell <JorellF-97jfqw80gc7k1uMJSBkQmQ@public.gmane.org>
Subject: linux-cifs 5.4 problems...
Date: Tue, 22 May 2012 11:55:02 -0700
Message-ID: <jpgne8$fod$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'm currently trying to compile linux-cifs 5.4 on debian squeeze.
I have a working compiled version of samba 3.6.5 installed using the=20
following:
=2E/autogen.sh && \
=2E/configure --with-automount --with-dnsupdate --with-winbind --with-a=
ds=20
--with-pam --with-acl-support --with-libtdb --with-libsmbclient \
--with-fhs \
--bindir=3D/usr/local/bin \
--sbindir=3D/usr/local/sbin \
--with-configdir=3D/usr/local/etc/samba \
--libdir=3D/usr/local/lib \
--with-mandir=3D/usr/local/share/man \
--with-piddir=3D/var/local/run/samba \
--with-statedir=3D/var/local/lib/samba \
--with-cachedir=3D/var/local/cache/samba \
--with-logfilebase=3D/var/local/log/samba \
--with-lockdir=3D/var/local/locks/samba \
--with-ncalrpcdir=3D/var/local/ncalrpc/samba \
--with-nmbdsocketdir=3D/var/local/nmbd/samba && \
make -j4 && make install;


here is the output from using the following command for cifs v5.4
=2E/configure && make -j4 && make install;

checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... no
checking for mawk... mawk
checking whether make sets $(MAKE)... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /bin/sed
checking how to run the C preprocessor... gcc -E
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking minix/config.h usability... no
checking minix/config.h presence... no
checking for minix/config.h... no
checking whether it is safe to define __EXTENSIONS__... yes
checking whether gcc and cc understand -c and -o together... yes
checking for stdbool.h that conforms to C99... yes
checking for _Bool... yes
checking for uid_t in sys/types.h... yes
checking for off_t... yes
checking for pid_t... yes
checking for size_t... yes
checking for ptrdiff_t... yes
checking for ssize_t... yes
checking for uint32_t... yes
checking for uint8_t... yes
checking for library containing getmntent... none required
checking whether lstat correctly handles trailing slash... yes
checking for stdlib.h... (cached) yes
checking for GNU libc compatible malloc... yes
checking for stdlib.h... (cached) yes
checking for GNU libc compatible realloc... yes
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking for working strnlen... yes
checking for alarm... yes
checking for atexit... yes
checking for endpwent... yes
checking for getmntent... (cached) yes
checking for getpass... yes
checking for gettimeofday... yes
checking for inet_ntop... yes
checking for memset... yes
checking for realpath... yes
checking for setenv... yes
checking for strchr... yes
checking for strcmp... yes
checking for strdup... yes
checking for strerror... yes
checking for strncasecmp... yes
checking for strndup... yes
checking for strpbrk... yes
checking for strrchr... yes
checking for strstr... yes
checking for strtol... yes
checking for strtoul... yes
checking for tolower... yes
checking for uname... yes
checking for clock_gettime... no
checking for clock_gettime in -lrt... yes
checking arpa/inet.h usability... yes
checking arpa/inet.h presence... yes
checking for arpa/inet.h... yes
checking ctype.h usability... yes
checking ctype.h presence... yes
checking for ctype.h... yes
checking fcntl.h usability... yes
checking fcntl.h presence... yes
checking for fcntl.h... yes
checking for inttypes.h... (cached) yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking mntent.h usability... yes
checking mntent.h presence... yes
checking for mntent.h... yes
checking netdb.h usability... yes
checking netdb.h presence... yes
checking for netdb.h... yes
checking stddef.h usability... yes
checking stddef.h presence... yes
checking for stddef.h... yes
checking for stdint.h... (cached) yes
checking for stdbool.h... (cached) yes
checking for stdlib.h... (cached) yes
checking stdio.h usability... yes
checking stdio.h presence... yes
checking for stdio.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking for string.h... (cached) yes
checking for strings.h... (cached) yes
checking sys/mount.h usability... yes
checking sys/mount.h presence... yes
checking for sys/mount.h... yes
checking sys/param.h usability... yes
checking sys/param.h presence... yes
checking for sys/param.h... yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking syslog.h usability... yes
checking syslog.h presence... yes
checking for syslog.h... yes
checking for unistd.h... (cached) yes
checking sys/fsuid.h usability... yes
checking sys/fsuid.h presence... yes
checking for sys/fsuid.h... yes
checking for setfsuid... yes
checking krb5.h usability... yes
checking krb5.h presence... yes
checking for krb5.h... yes
checking krb5/krb5.h usability... yes
checking krb5/krb5.h presence... yes
checking for krb5/krb5.h... yes
checking for keyvalue in krb5_keyblock... no
checking talloc.h usability... yes
checking talloc.h presence... yes
checking for talloc.h... yes
checking keyutils.h usability... yes
checking keyutils.h presence... yes
checking for keyutils.h... yes
checking for krb5_init_context in -lkrb5... yes
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for WBCLIENT... no
configure: WARNING: wbclient.h not found, consider installing=20
libwbclient-devel. Disabling cifs.idmap.
configure: WARNING: wbclient.h not found, consider installing=20
libwbclient-devel. Disabling cifsacl.
checking for keyutils.h... (cached) yes
checking for krb5_auth_con_getsendsubkey... yes
checking for krb5_principal_get_realm... no
checking for krb5_free_unparsed_name... yes
checking for krb5_auth_con_setaddrs... yes
checking for krb5_auth_con_set_req_cksumtype... yes
checking cap-ng.h usability... yes
checking cap-ng.h presence... yes
checking for cap-ng.h... yes
checking for capng_clear in -lcap-ng... yes
checking whether to use libcap-ng... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating contrib/Makefile
config.status: creating contrib/request-key.d/Makefile
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
make  all-recursive
make[1]: Entering directory `/root/build/buildd/cifs-utils-5.4'
Making all in contrib
make[2]: Entering directory `/root/build/buildd/cifs-utils-5.4/contrib'
Making all in request-key.d
make[3]: Entering directory=20
`/root/build/buildd/cifs-utils-5.4/contrib/request-key.d'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory=20
`/root/build/buildd/cifs-utils-5.4/contrib/request-key.d'
make[3]: Entering directory `/root/build/buildd/cifs-utils-5.4/contrib'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/root/build/buildd/cifs-utils-5.4/contrib'
make[2]: Leaving directory `/root/build/buildd/cifs-utils-5.4/contrib'
make[2]: Entering directory `/root/build/buildd/cifs-utils-5.4'
gcc -DHAVE_CONFIG_H -I.   -I/usr/local/samba -Wall -Wextra -Werror -g=20
-O2 -MT mount.cifs.o -MD -MP -MF .deps/mount.cifs.Tpo -c -o mount.cifs.=
o=20
mount.cifs.c
cc1: warnings being treated as errors
mount.cifs.c: In function =E2parse_options=E2:
mount.cifs.c:866: error: =E2bkupuid=E2 may be used uninitialized in thi=
s=20
function
mount.cifs.c:867: error: =E2bkupgid=E2 may be used uninitialized in thi=
s=20
function
make[2]: *** [mount.cifs.o] Error 1
make[2]: Leaving directory `/root/build/buildd/cifs-utils-5.4'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/root/build/buildd/cifs-utils-5.4'
make: *** [all] Error 2


Yes, I have tried "apt-get install libwbclient-dev"
