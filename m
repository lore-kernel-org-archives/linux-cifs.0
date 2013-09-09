From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: fix warning message on cifs-utils build - alternate package name for krb5.h
Date: Mon, 9 Sep 2013 09:59:38 -0500
Message-ID: <CAH2r5mtfa65ok=pCxT-y=xbdBMApsu5VExh33Bz_Ukkx5iD-Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit 5c69761267eb54ce0d94f3a30c3ad015efd3a806
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Mon Sep 9 09:55:46 2013 -0500

    [CIFS-UTILS] Add another suggested package name for krb5 headers

    Added an alternate package name for krb5 headers.

    Noticed the following suggestion asks for the wrong package (at least
    wrong for FC17)

    checking krb5.h presence... no
    checking for krb5.h... no
    checking krb5/krb5.h usability... no
    checking krb5/krb5.h presence... no
    checking for krb5/krb5.h... no
    configure: WARNING: krb5.h not found, consider installing
    krb5-libs-devel. Disabling cifs.upcall.

    [sfrench@w500smf cifs-utils]$ sudo yum install krb5-libs-devel
    Loaded plugins: langpacks, presto, refresh-packagekit
    No package krb5-libs-devel available.
    Error: Nothing to do
    [sfrench@w500smf cifs-utils]$ sudo yum install krb5-devel

    (installing krb5-devel worked, but not krb5-libs-devel for this version)

    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/configure.ac b/configure.ac
index b5f7c49..c69ede4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -135,9 +135,9 @@ if test $enable_cifsupcall != "no"; then
  if test x$ac_cv_header_krb5_krb5_h != xyes ; then
  if test x$ac_cv_header_krb5_h != xyes ; then
  if test "$enable_cifsupcall" = "yes"; then
- AC_MSG_ERROR([krb5.h not found, consider installing krb5-libs-devel.])
+ AC_MSG_ERROR([krb5.h not found, consider installing krb5-devel or
krb5-libs-devel.])
  else
- AC_MSG_WARN([krb5.h not found, consider installing krb5-libs-devel.
Disabling cifs.upcall.])
+ AC_MSG_WARN([krb5.h not found, consider installing krb5-devel or
krb5-libs-devel. Disabling cifs.upcall.])
  enable_cifsupcall="no"
  fi
  fi

-- 
Thanks,

Steve
