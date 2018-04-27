From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: copy_file_range and user space tools to do copy fastest
Date: Fri, 27 Apr 2018 13:45:40 -0600
Message-ID: <EFCB08E9-C9B9-41AC-A398-4D552FC8EFC9@dilger.ca>
References: <CAH2r5mtRF-yS6stThuVzem+WFmxDqpGLwFvUPviYcmh9dXXwkA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B057034D-F56C-457C-92FD-E74066759B39";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtRF-yS6stThuVzem+WFmxDqpGLwFvUPviYcmh9dXXwkA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--Apple-Mail=_B057034D-F56C-457C-92FD-E74066759B39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Apr 27, 2018, at 12:25 PM, Steve French <smfrench@gmail.com> wrote:
> 
> Are there any user space tools (other than our test tools and xfs_io
> etc.) that support copy_file_range?  Looks like at least cp and rsync
> and dd don't.  That syscall which now has been around a couple years,
> and was reminded about at the LSF/MM summit a few days ago, presumably
> is the 'best' way to copy a file fast since it tries all the
> mechanisms (reflink etc.) in order.
> 
> Since copy_file_range syscall can be 100x or more faster for network
> file systems than the alternative, was surprised when I noticed that
> cp and rsync didn't support it.  It doesn't look like rsync even
> supports reflink either(although presumably if you call
> copy_file_range you don't have to worry about that), and reads/writes
> are 8K. See copy_file() in rsync/util.c
> 
> In the cp command it looks like it can call the FICLONE IOCTL (see
> clone_file() in coreutils/src/copy.c) but doesn't call the expected
> "copy_file_range" syscall.
> 
> In the dd command it doesn't call either - see dd_copy in corutils/src/dd.c
> 
> Since it can be 100x or more faster in some cases to call
> copy_file_range than do reads/writes back and forth to do a copy
> (especially if network or clustered backend or cloud), what tools are
> the best to recommend?
> 
> Would rsync or cp be likely to take patches to call the standard
> "copy_file_range" syscall
> (http://man7.org/linux/man-pages/man2/copy_file_range.2.html)?
> Presumably not if it has been two+ years ... but would be interested
> what copy tools to recommend to use instead.

I would start with submitting a patch to coreutils, if you can figure
out that code enough to do so (I find it quite opaque).  Since it has
been in the kernel for a while already, it should be acceptable to the
upstream coreutils maintainers to use this interface.  Doubly so if you
include some benchmarks with CIFS/NFS clients avoiding network overhead
during the copy.

Cheers, Andreas






--Apple-Mail=_B057034D-F56C-457C-92FD-E74066759B39
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlrjfeUACgkQcqXauRfM
H+Cxog//Xhtr1d/eA30xmnuGVdFxXp7EjuKDZLsw/VOwtkqFVkJ7BKVMNjRzU6gu
CsfSf0OlLhyrCaZSdEy5H8C8tgRDSkM40xKFtpF9JKp9LGCr3sctLybUJXnwxcm4
AQxv/wKXGhY4KusdCVvguS+0P1cs9hkN1hKTqkOD7uzxmHmgT32pgHJ0NWO6RRHP
ajsW7vHiiVolRPBEkkpVeTShy3e5yQXdtzlzgU1F1ZmFdfZomh3G4UvJXSnROIzc
RPnPujICehohKzwyBstW4HxdiH+xj24HH1K7We7558SlmxN91e8M7PLPRDc42buh
yO5adK1HWmKlZJgJM7JFyskRNmfhtlNetob4In54XHolhUIsxwz5RxEZpHDM2fem
2wbEhmkAke54cvxBnRHXVnxzAsthOYCaskQgkLdGm3F8udOPw/4kZOK7c7ML7SpV
Z09Iijc0fFW0mt/OkUPReukwdSdc3KUsD6SIKRWHr0Ix724AYYbXIn2uw2aph3Gs
igNV2QrBj6kxsMxJ+dGZM3gTbn38jWWGtFDecWNvfPLsxVdUrbWS6KTOXjT8uKTn
rnIl9tjWk4lWhp+ktUL2U17R2c325vX3jqJFTLS9nZJAdbvHrGY5YRlyWeLdJqGx
9L2P9won5zWaW43M9tcS1xaB4PiPfs9+R3rLfybnLi8mY6Hbk/0=
=ou2D
-----END PGP SIGNATURE-----

--Apple-Mail=_B057034D-F56C-457C-92FD-E74066759B39--
