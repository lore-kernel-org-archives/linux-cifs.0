Received: from fabamailgate01.fabasoft.com (fabamailgate01.fabasoft.com [192.84.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5495413A3F7
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jan 2025 23:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.84.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737759924; cv=none; b=HLJLjXInfY3X+/gpEGAabX0WSge8LN2WAwDVMqovaq1+FZL2XBYM3tjIf7arTQJKKjyErCyUoYoStPag/AQiKrCMhF1P3hqjjlgQU/ZcZdtYR3y0OfcQbLFg8tLEP2NkXCHvzsYLGbo1XKc4/0puuQ5cUEriwYuAVJfeSNp1hMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737759924; c=relaxed/simple;
	bh=pdV/wEhDuA/ovVE4yppk4EG30Fw5A2+SQ6chMJaw79M=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=DsTeNEEQUsZJp4kRaqDxg6sPUy+oHG6LJ2lQbdP0fczZZ44viZgzFhnpD7VC41ZWeaRDs75nPX3Z779w9OC4sW3G+dE1koFf34ZatyABr0z1wV1OUPYJAHxyLLYzU1IKVVIS1R4px5IG/ETtXGLoIajoxrOCr6QyO7jfVBDCVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com; spf=pass smtp.mailfrom=fabasoft.com; arc=none smtp.client-ip=192.84.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fabasoft.com
Received: from fabamailgate01.fabasoft.com (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by fabamailgate01.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS id DB2752004130
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 00:05:17 +0100 (CET)
Received: from [127.0.0.1] (helo=fabamailgate01.fabasoft.com)
	by fabamailgate01.fabasoft.com with ESMTP (eXpurgate 4.51.0)
	(envelope-from <horst.reiterer@fabasoft.com>)
	id 67941cad-045f-7f0000012b03-7f000001dbf0-1
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 00:05:17 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com (fabaexch01 [10.10.5.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by fabamailgate01.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 00:05:17 +0100 (CET)
Received: from FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) by
 FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sat, 25 Jan 2025 00:05:17 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7]) by
 FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7%4]) with mapi id
 15.01.2507.044; Sat, 25 Jan 2025 00:05:17 +0100
From: "Reiterer, Horst" <horst.reiterer@fabasoft.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs.
 5.14.0-503.15.1.el9_5)
Thread-Topic: Regression: smb: chmod ignored (5.14.0-427.40.1.el9_4 vs.
 5.14.0-503.15.1.el9_5)
Thread-Index: AdturiUHVSVT8VVlSIaajlplMuoqUw==
Date: Fri, 24 Jan 2025 23:05:17 +0000
Message-ID: <85a16504e09147a195ac0aac1c801280@fabasoft.com>
Accept-Language: en-US, de-AT
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-purgate-ID: 152191::1737759917-DCFC7ACB-60320B6A/0/0
X-purgate-type: clean
X-purgate-size: 5653
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean

Hi,

after updating from AlmaLinux 9.4 to 9.5 (https://repo.almalinux.org/vault/=
9.4/BaseOS/Source/Packages/kernel-5.14.0-427.40.1.el9_4.src.rpm vs. https:/=
/repo.almalinux.org/vault/9.5/BaseOS/Source/Packages/kernel-5.14.0-503.15.1=
.el9_5.src.rpm), chmod gets ignored by the CIFS filesystem when executed ag=
ainst a Windows file server unless chmod happens in another process.

Mount options as reported by mount:

  rw,relatime,context=3Dsystem_u:object_r:tmp_t:s0,vers=3D3.1.1,cache=3Dstr=
ict,username=3D<username> =20
  uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D<addr>,file_mode=3D0755,dir_=
mode=3D0755,soft
  nounix,serverino,mapposix,reparse=3Dnfs,rsize=3D4194304,wsize=3D4194304,b=
size=3D1048576
  retrans=3D1,echo_interval=3D60,actimeo=3D1,closetimeo=3D1

Reproduction (see source below):

  ./test <path/to/mountpoint>/<non-existent-filename> all
  Unexpected mode 100555

strace:

openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
close(3)                                =3D 0
chmod("/mnt/test", 0400) =3D 0
openat(AT_FDCWD, "/mnt/test", O_RDONLY) =3D 3
close(3)                                =3D 0
newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D1407=
374884039565, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D0,=
 st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
37759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_atime_nsec=3D24255220=
0, st_mtime=3D1737759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_mtime=
_nsec=3D242552200, st_ctime=3D1737759300 /* 2025-01-
24T23:55:00.243552200+0100 */, st_ctime_nsec=3D243552200}, 0) =3D 0
chmod("/mnt/test", 0600) =3D 0
newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D1407=
374884039565, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D0,=
 st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
37759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_atime_nsec=3D24255220=
0, st_mtime=3D1737759300 /* 2025-01-24T23:55:00.242552200+0100 */, st_mtime=
_nsec=3D242552200, st_ctime=3D1737759300 /* 2025-01-
24T23:55:00.245552200+0100 */, st_ctime_nsec=3D245552200}, 0) =3D 0
write(2, "Unexpected mode 100555\n", 23Unexpected mode 100555
) =3D 23
exit_group(1)                           =3D ?
+++ exited with 1 +++

Workaround (executing the test in two processes):

  ./test <path/to/mountpoint>/<non-existent-filename> first
  ./test <path/to/mountpoint>/<non-existent-filename> last

strace:

openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
close(3)                                =3D 0
chmod("/mnt/test", 0400) =3D 0
openat(AT_FDCWD, "/mnt/test", O_RDONLY) =3D 3
close(3)                                =3D 0
exit_group(0)                           =3D ?
+++ exited with 0 +++

newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D1407=
374884039566, st_mode=3DS_IFREG|0555, st_nlink=3D1, st_uid=3D0, st_gid=3D0,=
 st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
37759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_atime_nsec=3D15293020=
0, st_mtime=3D1737759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_mtime=
_nsec=3D152930200, st_ctime=3D1737759424 /* 2025-01-
24T23:57:04.152930200+0100 */, st_ctime_nsec=3D152930200}, 0) =3D 0
chmod("/mnt/test", 0600) =3D 0
newfstatat(AT_FDCWD, "/mnt/test", {st_dev=3Dmakedev(0, 0x2b), st_ino=3D1407=
374884039566, st_mode=3DS_IFREG|0755, st_nlink=3D1, st_uid=3D0, st_gid=3D0,=
 st_blksize=3D1048576, st_blocks=3D0, st_size=3D0, st_atime=3D17
37759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_atime_nsec=3D15293020=
0, st_mtime=3D1737759424 /* 2025-01-24T23:57:04.152930200+0100 */, st_mtime=
_nsec=3D152930200, st_ctime=3D1737759449 /* 2025-01-
24T23:57:29.621213500+0100 */, st_ctime_nsec=3D621213500}, 0) =3D 0
openat(AT_FDCWD, "/mnt/test", O_WRONLY|O_CREAT|O_TRUNC, 0666) =3D 3
close(3)                                =3D 0
exit_group(0)                           =3D ?
+++ exited with 0 +++

Please let me know if your can reproduce the issue using the sample.

Cheers,

Horst Reiterer

test.c:
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
  if (argc !=3D 3) {
    fprintf(stderr, "test <path> <all|first|last>\n");
    return 2;
  }
  char *path =3D argv[1];
  char *mode =3D argv[2];
  int fd;
  if (strcmp(mode, "all") =3D=3D 0 || strcmp(mode, "first") =3D=3D 0) {
    if ((fd =3D open(path, O_WRONLY|O_CREAT|O_TRUNC, 0666)) =3D=3D -1) {
      perror("open");
      return 1;
    }
    close(fd);
    if (chmod(path, 0400) =3D=3D -1) {
      perror("chmod");
      return 1;
    }
    if ((fd =3D open(path, O_RDONLY)) =3D=3D -1) {
      perror("open");
      return 1;
    }
    close(fd);
  }
  if (strcmp(mode, "all") =3D=3D 0 || strcmp(mode, "last") =3D=3D 0) {
    struct stat statbuf;
    if (stat(path, &statbuf) =3D=3D -1) {
      perror("stat");
      return 1;
    }
    mode_t modebefore =3D statbuf.st_mode;
    if (chmod(path, 0600) =3D=3D -1) {
      perror("chmod");
      return 1;
    }
    if (stat(path, &statbuf) =3D=3D -1) {
      perror("stat");
      return 1;
    }
    if (statbuf.st_mode =3D=3D modebefore) {
      fprintf(stderr, "Unexpected mode %o\n", statbuf.st_mode);
      return 1;
    }
    if ((fd =3D open(path, O_WRONLY|O_CREAT|O_TRUNC, 0666)) =3D=3D -1) {
      perror("open");
      return 1;
    }
    close(fd);
  }
  return 0;
}
