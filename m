From: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes with linux-3.1-rc2
Date: Wed, 17 Aug 2011 19:31:09 -0400
Message-ID: <26399.1313623869@turing-police.cc.vt.edu>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
            <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313623869_2796P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Piszcz <ap-SDpCatL+S6WaMJb+Lgu22Q@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Justin Piszcz <jpiszcz-BP4nVm5VUdNhbmWW9KSYcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: Your message of "Wed, 17 Aug 2011 15:16:40 EDT."
             <alpine.DEB.2.02.1108171515050.5877-0qmrozcXWo8bm2hyYBkBBg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--==_Exmh_1313623869_2796P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Aug 2011 15:16:40 EDT, Justin Piszcz said:

> Tried with linux-3.1-rc2 and:
> 
> You don't even need to get a successful mount:
> 
> Does anyone know if any kernel supports CIFS w/out crashing? I'd like to 
> backup some CIFS shares, thanks.

3.1.0-rc1-next-20110808 is talking CIFS to our NetApp without any complaint.
Not heavily stress tested, but it mounted, I can see files, I can open files, I
specifically tried 'df' and didn't crash.

So I'm guessing there's some subtle difference between what my NetApp feeds my
laptop over the wire and what you're seeing from your Windows box?


--==_Exmh_1313623869_2796P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTE89cC3lWbTT17ARAnGZAKDjNIGBTZpkursKwWIiwlXHkk3D9QCfel2r
Q1bFNvO338NdGfRmwnWlhfk=
=+vGx
-----END PGP SIGNATURE-----

--==_Exmh_1313623869_2796P--
