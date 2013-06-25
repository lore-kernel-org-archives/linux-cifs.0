From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [PATCH v4 06/14] locks: encapsulate the fl_link list handling
Date: Tue, 25 Jun 2013 11:37:04 +1000
Message-ID: <20130625113704.89a686a55dcec684e5e99434@canb.auug.org.au>
References: <1371819502-26363-1-git-send-email-jlayton@redhat.com>
	<1371819502-26363-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_11_37_04_+1000_dzYhDLAz_=0wCCci"
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371819502-26363-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--Signature=_Tue__25_Jun_2013_11_37_04_+1000_dzYhDLAz_=0wCCci
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

Thanks for doing all this work!

Trivial comments below.

On Fri, 21 Jun 2013 08:58:14 -0400 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> +static inline void
> +locks_insert_global_locks(struct file_lock *fl)
> +{
> +	list_add_tail(&fl->fl_link, &file_lock_list);
> +}

We generally do not use "inline" in C files any more and leave it to the
compiler to do that.  Also, without the "inline" these function headers
should all be able to fit on single lines like the others here i.e.

static void locks_insert_global_locks(struct file_lock *fl)

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

--Signature=_Tue__25_Jun_2013_11_37_04_+1000_dzYhDLAz_=0wCCci
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyPREAAoJEECxmPOUX5FEfWIP/1Fcte7TTx0cYdMFqxD6iYFF
I5QuoxOCEek37xGFhXwztvoI+llIdSH4xYaZXtVyC01jxfejNfGOW6JOuxRWrMCW
4o0doZNE7fX1CaPJv+O8HS0qGVGVL4En0ZJJrPtjImbrUP1rg+bKAI4GwTZTcxfH
eDr8Oey4xzzSFR/am+e7IyEjAW4gA7EIOpG4PjcMP+LEbTKOaybUDZBs+IwRBiPL
ERyuwyW1mdAh5Cd5rssT72osOSq36WvK7f0w7hdzenmJFj5SUY4mmWdQz25J79ZC
5LOfPxcgZWAv48F4VmmKh0v555f7hVGdtf1eE4cwckzWDQAvvPY27xSFNaYWwvd9
jpDVPR0CcJeJkRR4qpGE6OO9dRGCoq8aNAmln0ix4ehb7+rGt4KMO0vOplFmfb1y
oiL/Uzc2WuoFJDQCU1f7Z3EmcBKZBxS+Hs67xuvulBAubLY4r0uYMcA6RLgsbHB7
k/eyUk9Rsce39jdPNPkFM1AB92F5AvdmaqROH2NKRh9lNOmZDNxxQ3v/9XU9oY6t
1uNs9dL7H9f2MaMeG4Yx9ircj+NdB7vwbauYlAv/9D1fxRhqoKO1M292CbWhv/l0
OwcF9Nz9e6aHHZc8HnZzlKjzRaoqJ83eFekWk4RZbmNhEmlLDzHUXfqrke6fn8pn
Y1vM5HPDCfSDb/sVAmbd
=q+vx
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_11_37_04_+1000_dzYhDLAz_=0wCCci--
