From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/8] cifs-utils: cifsacl utilities: Add configure and make
 directives for cifsacl (try #2)
Date: Thu, 25 Aug 2011 13:50:06 -0500
Message-ID: <CADT32eLM0o66OLw2Xm2qN-yW1kFfnQHWO-c601BVBsSKr4aZPg@mail.gmail.com>
References: <1314126264-12107-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110825143402.31dbfd5e@barsoom.rdu.redhat.com>
	<CADT32eK2TcrGgu8dSqHur2L95xO4ha47Kt4si_LhrLnwAkXARw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eK2TcrGgu8dSqHur2L95xO4ha47Kt4si_LhrLnwAkXARw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 25, 2011 at 1:40 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Aug 25, 2011 at 1:34 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
>> On Tue, 23 Aug 2011 14:04:24 -0500
>> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>>
>>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>
>>>
>>> Add configure directives for option cifsacl. =A0The default action =
is
>>> to enable cifsacl option.
>>> cifsacl option is enabled or disabled in a similar way to cifs.idma=
p
>>> in the same function. In addition, for cifsacl, check for sys/xattr=
=2Eh
>>> is done in the smae .m4 file.
>>>
>>> Add directives to build getcifsacl in Makefile.
>>>
>>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> =A0Makefile.am =A0 =A0 =A0| =A0 17 ++++++++++++++++-
>>> =A0aclocal/idmap.m4 | =A0 23 ++++++++++++++++++++---
>>> =A0configure.ac =A0 =A0 | =A0 17 +++++++++++++++++
>>> =A03 files changed, 53 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/Makefile.am b/Makefile.am
>>> index 4938447..3ec6b7e 100644
>>> --- a/Makefile.am
>>> +++ b/Makefile.am
>>> @@ -9,7 +9,7 @@ mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD)
>>> =A0man_MANS =3D mount.cifs.8
>>>
>>> =A0sbin_PROGRAMS =3D
>>> -clean-local: clean-local-upcall clean-local-idmap
>>> +clean-local: clean-local-upcall clean-local-idmap clean-local-aclp=
rogs
>>>
>>> =A0if CONFIG_CIFSUPCALL
>>> =A0sbin_PROGRAMS +=3D cifs.upcall
>>> @@ -50,3 +50,18 @@ clean-local-idmap:
>>> =A0if CONFIG_CIFSIDMAP
>>> =A0 =A0 =A0 rm -f cifs.idmap.8 cifs.idmap.8-t
>>> =A0endif
>>> +
>>> +if CONFIG_CIFSACL
>>> +sbin_PROGRAMS +=3D getcifsacl
>>> +getcifsacl_SOURCES =3D getcifsacl.c
>>> +getcifsacl_LDADD =3D -lkeyutils $(WINB_LDADD)
>>> +man_MANS +=3D getcifsacl.8
>>> +
>>> +getcifsacl.8: getcifsacl.8.in
>>> + =A0 =A0 $(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t=
 && mv $@-t $@
>>> +endif
>>> +
>>> +clean-local-aclprogs:
>>> +if CONFIG_CIFSACL
>>> + =A0 =A0 rm -f getcifsacl.8 getcifsacl.8-t
>>> +endif
>>> diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
>>> index 211d372..ada73f0 100644
>>> --- a/aclocal/idmap.m4
>>> +++ b/aclocal/idmap.m4
>>> @@ -23,10 +23,10 @@ AC_DEFUN([AC_WBCH_COMPL],[
>>> =A0#endif
>>> =A0]])
>>>
>>> -dnl Check for wbclient.h header and libwbclietn.so
>>> +dnl Check for wbclient.h header and libwbclient.so
>>> =A0dnl
>>> =A0AC_DEFUN([AC_TEST_WBCHL],[
>>> -if test $enable_cifsidmap !=3D "no"; then
>>> +if test $enable_cifsidmap !=3D "no" -o $enable_cifsacl !=3D "no"; =
then
>>> =A0 =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test=
 "$enable_cifsidmap" =3D "yes"; then
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbc=
lient-devel.])
>>> @@ -34,10 +34,27 @@ if test $enable_cifsidmap !=3D "no"; then
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbcl=
ient-devel. Disabling cifs.idmap.])
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 enable_cifsidmap=3D"no"
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test "=
$enable_cifsacl" =3D "yes"; then
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbclien=
t-devel.])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbclient=
-devel. Disabling cifsacl.])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enable_cifsacl=3D"no"
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ], [ AC_WBCH_COMPL ])
>>> =A0fi
>>>
>>> -if test $enable_cifsidmap !=3D "no"; then
>>> +if test $enable_cifsacl !=3D "no"; then
>>> + =A0 =A0 AC_CHECK_HEADERS([sys/xattr.h], , [
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test "=
$enable_cifsacl" =3D "yes"; then
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_ERROR([/usr/include/sys/xattr.h not found])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_WARN([/usr/include/sys/xattr.h not found. Disabling cifsacl=
=2E])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enable_cifsacl=3D"no"
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ], [ ])
>>> +fi
>>> +
>>> +if test $enable_cifsidmap !=3D "no" -o $enable_cifsacl !=3D "no"; =
then
>>> =A0 =A0 =A0 AC_CHECK_LIB([wbclient], [wbcStringToSid],
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ WINB_LDADD=3D'-lwbclient' ] [ AC_DEFI=
NE(HAVE_LIBWBCLIENT, 1, ["Define var have_libwbclient"]) ], [AC_MSG_ERR=
OR([No functioning wbclient library found!])])
>>> =A0 =A0 =A0 AC_SUBST(WINB_LDADD)
>>> diff --git a/configure.ac b/configure.ac
>>> index 780abe7..293415f 100644
>>> --- a/configure.ac
>>> +++ b/configure.ac
>>> @@ -28,6 +28,12 @@ AC_ARG_ENABLE(cifsidmap,
>>> =A0 =A0 =A0 enable_cifsidmap=3D$enableval,
>>> =A0 =A0 =A0 enable_cifsidmap=3D"maybe")
>>>
>>> +AC_ARG_ENABLE(cifsacl,
>>> + =A0 =A0 [AC_HELP_STRING([--enable-cifsacl],
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [Create get/set cifsacl b=
inary @<:@default=3Dyes@:>@])],
>>> + =A0 =A0 enable_cifsacl=3D$enableval,
>>> + =A0 =A0 enable_cifsacl=3D"maybe")
>>> +
>>> =A0# Checks for programs.
>>> =A0AC_PROG_CC
>>> =A0AC_PROG_SED
>>> @@ -94,6 +100,16 @@ if test $enable_cifsupcall !=3D "no" -o $enable=
_cifsidmap !=3D "no"; then
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
>>> =A0fi
>>> +if test $enable_cifsacl !=3D "no"; then
>>> + =A0 =A0 AC_CHECK_HEADERS([wbclient.h], , [
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if test "=
$enable_cifsacl" =3D "yes"; then
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_ERROR([wbclient.h not found, consider installing libwbclien=
t-devel.])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 AC_MSG_WARN([wbclient.h not found, consider installing libwbclient=
-devel. Disabling getcifsacl.])
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enable_cifsacl=3D"no"
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ])
>>> +fi
>>> =A0if test $enable_cifsupcall !=3D "no"; then
>>> =A0 =A0 =A0 AC_CHECK_LIB([krb5], [krb5_init_context],
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ KRB5_LDADD=3D'-lkrb5'=
 ],
>>> @@ -156,6 +172,7 @@ LIBS=3D$cu_saved_libs
>>> =A0AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" !=3D=
 "no"])
>>> =A0AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" =3D "=
yes"])
>>> =A0AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" !=3D =
"no"])
>>> +AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" !=3D "no"])
>>>
>>> =A0LIBCAP_NG_PATH
>>>
>>> --
>>> 1.6.0.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
>>
>> I started pulling these in and ran into a snag...
>>
>> checking wbclient.h presence... yes
>> configure: WARNING: wbclient.h: present but cannot be compiled
>> configure: WARNING: wbclient.h: =A0 =A0 check for missing prerequisi=
te headers?
>> configure: WARNING: wbclient.h: see the Autoconf documentation
>> configure: WARNING: wbclient.h: =A0 =A0 section "Present But Cannot =
Be Compiled"
>> configure: WARNING: wbclient.h: proceeding with the compiler's resul=
t
>> configure: WARNING: =A0 =A0 ## ----------------------------------- #=
#
>> configure: WARNING: =A0 =A0 ## Report this to cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org #=
#
>> configure: WARNING: =A0 =A0 ## ----------------------------------- #=
#
>>
>> ...according to config.log:
>>
>> configure:4410: gcc -c -g -O2 =A0conftest.c >&5
>> In file included from conftest.c:84:0:
>> /usr/include/wbclient.h:664:5: error: unknown type name 'bool'
>> configure:4410: $? =3D 1
>> configure: failed program was:
>>
>> ...this looks like a bug in wbclient.h, actually. It should be
>> including stdbool.h before trying to use a bool. Unfortunately thoug=
h,
>> we're likely going to need to work around this bug. I know there's a
>> way to make autoconf tests pull in extra includes, but I don't have =
my
>> autoconf book handy.
>>
>> Shirish, can you look into this, fix it and resubmit this patch?
>>
>> Simo tells me there's an open samba bug to fix this...
>>
>> --
>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>
> Jeff, yes. But this is not the first time wbclient.h has been used,
> cifs.idmap.c needed it earlier. Has something changed now that
> this is popping up? Looking into it.
>
> Regards,
>
> Shirish
>

I see it. But does not look like a show stopper i.e. getcifsacl,
setcifsacl, cifs.idmap are built and work.
But the error needs to be fixed. I think I had seen this and
could not think of a way to eliminate it (during cifs.idmap code)
but do not remember clearly why.

Regards,

Shirish
