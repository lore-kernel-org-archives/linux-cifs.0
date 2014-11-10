From: Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] [CIFS] Fix signed/unsigned pointer warning
Date: Mon, 10 Nov 2014 13:09:23 -0800
Message-ID: <1415653764-22162-1-git-send-email-cernekee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 2ae83bf93882d1 ("[CIFS] Fix setting time before epoch (negative
time values)") changed "u64 t" to "s64 t", which makes do_div() complai=
n
about a pointer signedness mismatch:

      CC      fs/cifs/netmisc.o
    In file included from ./arch/mips/include/asm/div64.h:12:0,
                     from include/linux/kernel.h:124,
                     from include/linux/list.h:8,
                     from include/linux/wait.h:6,
                     from include/linux/net.h:23,
                     from fs/cifs/netmisc.c:25:
    fs/cifs/netmisc.c: In function =E2=80=98cifs_NTtimeToUnix=E2=80=99:
    include/asm-generic/div64.h:43:28: warning: comparison of distinct =
pointer types lacks a cast [enabled by default]
      (void)(((typeof((n)) *)0) =3D=3D ((uint64_t *)0)); \
                                ^
    fs/cifs/netmisc.c:941:22: note: in expansion of macro =E2=80=98do_d=
iv=E2=80=99
       ts.tv_nsec =3D (long)do_div(t, 10000000) * 100;

Introduce a temporary "u64 abs_t" variable to fix this.

Signed-off-by: Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/netmisc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


Note: this is compile-tested only (on a 32-bit build).


diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index b333ff6..abae6dd 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -926,6 +926,7 @@ cifs_NTtimeToUnix(__le64 ntutc)
=20
 	/* Subtract the NTFS time offset, then convert to 1s intervals. */
 	s64 t =3D le64_to_cpu(ntutc) - NTFS_TIME_OFFSET;
+	u64 abs_t;
=20
 	/*
 	 * Unfortunately can not use normal 64 bit division on 32 bit arch, b=
ut
@@ -933,13 +934,14 @@ cifs_NTtimeToUnix(__le64 ntutc)
 	 * to special case them
 	 */
 	if (t < 0) {
-		t =3D -t;
-		ts.tv_nsec =3D (long)(do_div(t, 10000000) * 100);
+		abs_t =3D -t;
+		ts.tv_nsec =3D (long)(do_div(abs_t, 10000000) * 100);
 		ts.tv_nsec =3D -ts.tv_nsec;
-		ts.tv_sec =3D -t;
+		ts.tv_sec =3D -abs_t;
 	} else {
-		ts.tv_nsec =3D (long)do_div(t, 10000000) * 100;
-		ts.tv_sec =3D t;
+		abs_t =3D t;
+		ts.tv_nsec =3D (long)do_div(abs_t, 10000000) * 100;
+		ts.tv_sec =3D abs_t;
 	}
=20
 	return ts;
--=20
2.1.1
