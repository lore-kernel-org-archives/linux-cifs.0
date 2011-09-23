From: Jeff Layton <jlayton@samba.org>
Subject: ANNOUNCE: cifs-utils release 5.1 available for download
Date: Fri, 23 Sep 2011 13:59:07 -0400
Message-ID: <20110923135907.2d592a2c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	samba@samba.org
Return-path: <samba-technical-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

We've had a number of changes since the last release, and we have some
other upcoming kernel changes that might require corresponding
cifs-utils changes. So it's probably as good a time as any for a new
release.

Highlights:

+ fix for a minor security issue that can corrupt the mtab

+ new getcifsacl/setcifsacl tools that allow you to fetch and set raw
  Windows ACLs via an xattr.

+ a lot of manpage patches

webpage:    http://linux-cifs.samba.org/cifs-utils/
tarball:    ftp://ftp.samba.org/pub/linux-cifs/cifs-utils/
git:        git://git.samba.org/cifs-utils.git
gitweb:     http://git.samba.org/?p=3Dcifs-utils.git;a=3Dsummary

Detailed list of changes since 5.0:

commit 2c9e666011c352605a019ee82f39eefb53cc6ad8
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Jul 8 09:59:26 2011 -0400

    autoconf: bump release number to 5.0.1 for interim builds
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 775610358cb4cff8a6f322d0e8d5fade078f6f54
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Jul 12 07:30:57 2011 -0400

    manpage: add some missing options to mount.cifs.8
   =20
    Clarify servernetbiosname parameter name, add mention of ignorecase, and
    add a section on noposixpaths.
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit f6eae44a3d05b6515a59651e6bed8b6dde689aec
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Jul 12 08:19:33 2011 -0400

    mtab: handle ENOSPC/EFBIG condition properly when altering mtab
   =20
    It's possible that when mount.cifs goes to append the mtab that there
    won't be enough space to do so, and the mntent won't be appended to the
    file in its entirety.
   =20
    Add a my_endmntent routine that will fflush and then fsync the FILE if
    that succeeds. If either fails then it will truncate the file back to
    its provided size. It will then call endmntent unconditionally.
   =20
    Have add_mtab call fstat on the opened mtab file in order to get the
    size of the file before it has been appended. Assuming that that
    succeeds, use my_endmntent to ensure that the file is not corrupted
    before closing it. It's possible that we'll have a small race window
    where the mtab is incorrect, but it should be quickly corrected.
   =20
    This was reported some time ago as CVE-2011-1678:
   =20
        http://openwall.com/lists/oss-security/2011/03/04/9
   =20
    ...and it seems to fix the reproducer that I was able to come up with.
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>
    Reviewed-by: Suresh Jayaraman <sjayaraman@suse.de>

commit aa442e80e754f2952b0d90dbdbf2cb2807816ed2
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Mon Jul 18 12:06:03 2011 -0400

    manpages: add contents for mount option cifsacl (try #3)
   =20
    Manpage contents for cifs mount option cifsacl
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit d791892d901adde0dfb9e8d1099488f078704c73
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Jul 19 08:12:13 2011 -0400

    manpage: corrections and cleanups to the cifsacl option sections
   =20
    ..also update the part that describes what kernel version this manpage
    is accurate against.
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 861824f588a870da7c110b6f199eb5ce7d4dc476
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Jul 19 14:53:47 2011 -0400

    cifs-utils: add a note about inclusion of keys.dns_resolver program in =
keyutils
   =20
    As of version 1.5, the keyutils package is shipping a generic
    dns_resolver upcall. Add a note to the cifs.upcall manpage that mentions
    this and recommends the use of that program over cifs.upcall.
   =20
    Eventually, we may want to be able to conditionally compile out the
    dns_resolver part of the upcall, but it's already pretty small and
    wouldn't save us very much.
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 1e7a32924b22d1f786b6f490ce8590656f578f91
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Jul 29 07:12:48 2011 -0400

    mount.cifs: check_newline returns EX_USAGE on error, not -1
   =20
    Reported-by: Jan Lieskovsky <jlieskov@redhat.com>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit e0bb4418f79cb8670d06170fcd33c286839d258e
Author: Jeff Layton <jlayton@samba.org>
Date:   Tue Aug 23 09:02:11 2011 -0400

    autoconf: fix help message for --enable-cifsidmap
   =20
    It currently says "no" is the default, but it should be "yes".
   =20
    Reported-by: Elias Pipping <pipping@lavabit.com>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 86ec330e309af06459f8e64aad7899fd3fb7a9bf
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add file cifsacl.h (try #2)
   =20
   =20
    Add defines and structures related to security descriptor, ACL,
    ACE, various fields within an ACE, and SID.
    Also define various file permissions and acess types.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 7b090a36a06efec017ebf12a733136ea3968a637
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add file getcifsacl.c (try #2)
   =20
   =20
    Parse the blob that contains a security descriptor obtained by
    calling getxattr API using attribute system.cifs_acl .
    Start parsing and printing security descriptor including
    the a DACL within the security descriptor, printing each ACE of
    the DACL by printing SID, type, flags, and mask.
   =20
    Winbind apis are used to translate raw SID to a name.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 40ceb8b880f7149b6e703a8544ea6f8a326c93ea
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add file setcifsacl.c (try #2)
   =20
   =20
    Parse the blob that contains a security descriptor obtained by
    calling getxattr API using attribute system.cifs_acl .
    Start parsing and printing security descriptor including
    the a DACL within the security descriptor, printing each ACE of
    the DACL by printing SID, type, flags, and mask.
   =20
    Winbind apis are used to translate raw SID to a name.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit f335c7262f7871e727f357ff6008849e38df0157
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add man pages for getcifsacl (try #2)
   =20
   =20
    Man pages for utility getcifsacl.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit b713dd5f29a60fff178b372841173fa7fabdf00c
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add man pages for setcifsacl (try #5)
   =20
    Man pages for utility setcifsacl.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 5ee1ac229d3738520d308e4ddcd170b9b5026ceb
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Change contents of mount.cifs manpage (try #2)
   =20
   =20
    State getcifsacl and setcifsacl utilities to manipulate get/set xattr b=
lob
    respectively.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 06678a909ee842193b95b140fb198f85e3addfef
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add configure and make directives for cifsacl (try #2)
   =20
   =20
    Add configure directives for option cifsacl.  The default action is
    to enable cifsacl option.
    cifsacl option is enabled or disabled in a similar way to cifs.idmap
    in the same function. In addition, for cifsacl, check for sys/xattr.h
    is done in the smae .m4 file.
   =20
    Add directives to build getcifsacl in Makefile.
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit 99146a02be1ec098f7802ee8e6bb8d31b01cf344
Author: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Date:   Thu Aug 25 14:16:23 2011 -0400

    cifsacl: Add make directives for setcifsacl (try #2)
   =20
   =20
    Add Makefile directives for setcifsacl.
   =20
   =20
    Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>

commit aba2fc157c6d45063623615ab25ee24d44c149e5
Date:   Thu Aug 25 14:16:26 2011 -0400

    cifsacl: fix whitespace problem in setcifsacl.c
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit fa80f0150ad1803a2705c6a153cf5b64cc18a2d6
Author: Jeff Layton <jlayton@samba.org>
Date:   Thu Aug 25 16:37:33 2011 -0400

    autoconf: work around broken wbclient.h file
   =20
    Some versions of wbclient.h have function declarations with bool type
    args, but they don't include stdbool.h themselves. Make sure that
    we can deal with that by telling the autoconf test to include stdbool.h
    explicitly. In order to do that properly we need to move some of the
    standard header and type tests up in the file.
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 03636114ab55bebe33f28cacaab40c1f1efb1c07
Author: Pavel Shilovsky <piastry@etersoft.ru>
Date:   Mon Aug 29 12:57:03 2011 -0400

    mount.cifs: fix the conflict between rwpidforward and rw mount options
   =20
    Both these options are started with "rw" - that's why the first one
    isn't switched on even if it is specified. Fix this by adding a length
    check for "rw" option check.
   =20
    Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>

commit 6f8711840e0a812ffa5140243d3adfe0aed64e98
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Sep 23 12:29:24 2011 -0400

    manpage: document sec=3Dntlmssp(i) and clean up discussion of signing
   =20
    Acked-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 3956417185b257b877184b04e035254000e8eafe
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Sep 23 12:51:28 2011 -0400

    setcifsacl: remove unused rc var from build_cmdline_aces
   =20
    ...and eliminate this build warning:
   =20
    setcifsacl.c: In function =E2=80=98build_cmdline_aces=E2=80=99:
    setcifsacl.c:582:9: warning: variable =E2=80=98rc=E2=80=99 set but not =
used [-Wunused-but-set-variable]
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit edfa09f5b254dd52e0954abf635048cbd62d08ec
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Sep 23 12:51:28 2011 -0400

    autoconf: set version to 5.1
   =20
    Signed-off-by: Jeff Layton <jlayton@samba.org>

--=20
Jeff Layton <jlayton@samba.org>
