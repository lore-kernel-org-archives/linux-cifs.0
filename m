From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH] posix acls: Move namespace conversion
	into filesystem / xattr handlers
Date: Tue, 24 May 2016 14:47:57 -0600
Message-ID: <E0CE5625-120A-4DA7-ADC8-648A7A01D1AB@dilger.ca>
References: <1464008989-3812-1-git-send-email-agruenba@redhat.com>
	<20160524084724.GA8121@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/mixed; boundary="===============5578371103506747329=="
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org Development" <lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
In-Reply-To: <20160524084724.GA8121-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <http://lists.lustre.org/options.cgi/lustre-devel-lustre.org>,
	<mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.lustre.org/pipermail/lustre-devel-lustre.org/>
List-Post: <mailto:lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Help: <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org>,
	<mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=subscribe>
Errors-To: lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
Sender: "lustre-devel" <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Id: linux-cifs.vger.kernel.org


--===============5578371103506747329==
Content-Type: multipart/signed; boundary="Apple-Mail=_CD93CA6B-200A-44D4-969C-19A7A2CD3668"; protocol="application/pgp-signature"; micalg=pgp-sha256


--Apple-Mail=_CD93CA6B-200A-44D4-969C-19A7A2CD3668
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On May 24, 2016, at 2:47 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> On Mon, May 23, 2016 at 03:09:49PM +0200, Andreas Gruenbacher wrote:
>> I'm reasonably confident about the core and cifs changes in this patch.
>> The lustre code is pretty weird though, so could I please get a careful
>> review on the changes there?
> 
> Lustre is in the staging tree because it's an unrescuable piece of junk.
> Please just ignore it and move the proper parts of the kernel forward.

Don't be shy Christoph, tell us how you really feel about Lustre... :-)


Fortunately, that "piece of junk" is working fine and is running on most of
the supercomputers in the world (9 of the top 10, 70%+ of the top 100, ...)
with several sites having 50PB+ of storage, and 1TB/s+ to 20000+ clients,
in a single coherent POSIX filesystem.

It's true that the staging client isn't getting cleaned up as fast as
anyone likes, but that is because it is complex software in use at many
sites for many years and we can't just stop to completely rewrite the
code and hope it still works.  Even XFS took many years to get rid of the
IRIX wrapping layers, and still does a lot of things outside of the VFS/VM
(stats, memory allocation, IO submission, etc.) because the VFS/VM doesn't
work the way XFS wants it to (or vice versa).  This is not a slight against
XFS, just a sign that non-trivial filesystems take a long time to change
while maintaining existing functionality.  This is mainly a difference in
how code is added to the kernel today vs. how it was added back then.


Cheers, Andreas






--Apple-Mail=_CD93CA6B-200A-44D4-969C-19A7A2CD3668
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV0S9/nKl2rkXzB/gAQj1pw/8DhUZOC1I9x5gi5bQGZxrXf5ujBjxJzDC
qmI/fPL90wlSQm1l7LjkjQgmYSc23/jym3FqzudFHzQb83myziQMi/pMJ7iEIucT
CF+rCsxj5NXU6qZ9GJX4G+IESKD5dVQ1pEv9+/MXsf+3fN9efZJTCLVDEabCvei7
2HRPTq8vrkU0tI4s4fpXv9UoOvPWvmPsQm9y0uqwYR+P6hhTOVtLXFPHdIYmQd+m
zR7m057kEliWwLPBSGjouKCNOiVQ8JLJwIeX7TbwT3PDKiphXFx4qC9ScQX4Nzy5
H7ZjtHMMS8aEuJR7hdL1GXwdUWWCu/0JCICb4OINDTQGG8BVvQ2oulipti9/8oyd
GdZHUdi4AfLTkbWdRVow1eubBWaMSbrqgoz18gIYnzmjDreHr7RlcIQS+29L/AiA
ADhrrgyMsuHV0R9jYwNsGIStLwcJqgIA2qW2ZX8GfJdF4TZuqnLu0KXNXXSbc4Sd
TJNJmSXXsAvE3FBDWd2itEP1EwTy3QcjK6wb2k0vb6DBRvZN3phDGR8bqz4rnPz3
xj8+jlNo/sPBsMANId9sObLF/0CJOH0/ti8s/ywOK52ROK+iT8osYFjfyt4dNHF7
fEsMLytwtqZeQPlWElHwh4HIxtDRD5o0xLd3R86PyGAYEsOFL9b+QdVPwarioZtK
zZJLvz5i948=
=aZLY
-----END PGP SIGNATURE-----

--Apple-Mail=_CD93CA6B-200A-44D4-969C-19A7A2CD3668--

--===============5578371103506747329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
lustre-devel mailing list
lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org

--===============5578371103506747329==--
