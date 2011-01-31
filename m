From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Mon, 31 Jan 2011 16:19:51 +0530
Message-ID: <4D4693CF.9090903@suse.de>
References: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>,
	Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve French <smfrench@gmail.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 01/31/2011 08:00 AM, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> fs/cifs/file.c: In function 'cifs_iovec_write':
> fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' f=
rom incompatible pointer type
> fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argument=
 is of type 'size_t *'
>=20
> Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS:
> Implement cifs_strict_writev (try #4)").
>=20

The following patch should silence that warning.

=46rom: Suresh Jayaraman <sjayaraman@suse.de>
Subject: [PATCH] cifs: fix compiler warning about incompatible pointer =
type

fs/cifs/file.c: In function =91cifs_iovec_write=92:
fs/cifs/file.c:1740:9: warning: passing argument 6 of =91CIFSSMBWrite2=92=
 from incompatible pointer type
fs/cifs/cifsproto.h:343:12: note: expected =91unsigned int *=92 but arg=
ument is of type =91size_t *=92

Cc: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0de17c1..2a3c5d8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1667,7 +1667,7 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written =3D 0, written =3D 0;
+	unsigned int total_written =3D 0, written =3D 0;
 	unsigned long num_pages, npages;
 	size_t copied, len, cur_len, i;
 	struct kvec *to_send;
