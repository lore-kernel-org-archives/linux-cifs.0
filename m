From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB: Revert "remove redundant INFINIBAND kconfig
 dependencies"
Date: Sat, 26 May 2018 00:38:53 +0300
Message-ID: <20180525213853.GF22686@mtr-leonro.mtl.com>
References: <20180525213123.2113748-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        James Simmons <jsimmons@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve French <sfrench@samba.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayto
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180525213123.2113748-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 25, 2018 at 11:29:59PM +0200, Arnd Bergmann wrote:
> Several subsystems depend on INFINIBAND_ADDR_TRANS, which in turn depends
> on INFINIBAND. However, when with CONFIG_INIFIBAND=m, this leads to a
> link error when another driver using it is built-in. The
> INFINIBAND_ADDR_TRANS dependency is insufficient here as this is
> a 'bool' symbol that does not force anything to be a module in turn.
>
> fs/cifs/smbdirect.o: In function `smbd_disconnect_rdma_work':
> smbdirect.c:(.text+0x1e4): undefined reference to `rdma_disconnect'
> net/9p/trans_rdma.o: In function `rdma_request':
> trans_rdma.c:(.text+0x7bc): undefined reference to `rdma_disconnect'
> net/9p/trans_rdma.o: In function `rdma_destroy_trans':
> trans_rdma.c:(.text+0x830): undefined reference to `ib_destroy_qp'
> trans_rdma.c:(.text+0x858): undefined reference to `ib_dealloc_pd'
>
> Fixes: 9533b292a7ac ("IB: remove redundant INFINIBAND kconfig dependencies")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The patch that introduced the problem has been queued in the
> rdma-fixes/for-rc tree. Please revert the patch before sending
> the branch to Linus.
> ---

It was already sent to Linus.

https://marc.info/?l=linux-rdma&m=152719509803047&w=2

Thanks

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbCIJtAAoJEORje4g2clinFugQAIYNk8j6aOAN2MHradS5y6Ef
GeQY7/H9j2PkMeK+KL4gf6bCHzvcgS/wqdrVMdl/TIc60iyNBL/UJwn5mjsNmRx5
BG2B3VuXP0ZQNPouvyC9oCMq+fNJjeuvzWlHTz3Q8pjwwMuwDdbAaNCMbbEViZS8
AhLcZtDxeTcrFaiSrjkzUfxcb7/rBxOInMlq90Xb4VGDKq6vK1rK18MszFOYI+1C
l6KCeRbnDxAHvZFoIMzQOXM35AQoucGqRa8L14/go3eVKrIJPHowEC6/C4k5srsW
pzMU1yktzdZKs1E7w8iHLxFQqHp6uiZKOEgBnTNRaSZbTfq5MNTb55uCsjJ3mlrd
/YVa2sadrr+Ym4f058AKvt8y3kO71Yu7hTCg6UTPv9EJg94qUQ9apJMNVD9EUVzM
7ZO7tez/WGsyai6PFv+gx1iZiJHpl9TXI5uYxPLsdz0EU5+dsB9pQCsNk8y0tTFZ
aQeCLKxC5sqiDllBdECv2KQ2jOvnUy8PTx8VoV8e7kXaUI3YBSjHW+0x7wJgJJrZ
5CEjW3cVCLvW3Iwp0dDnHyqX1Tp7cdEnJx4bzXBArVy+BlpDa0yrMKxNWaZnvRXf
OBmwZxMlpRzpDpuA0lzwcTtO8fraJF8GyqrB9bCrVyHqcqziuduHroF6D4pU4s2X
mWd8FMSweTSM6kPt2ytV
=rjKg
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
