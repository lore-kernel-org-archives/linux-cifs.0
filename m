From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix error handling when cifscreds key payload is
 an error
Date: Wed, 25 Jan 2012 10:32:57 +0300
Message-ID: <20120125073257.GV3356@mwanda>
References: <1327064677-15896-1-git-send-email-jlayton@redhat.com>
 <CAH2r5mtTtYzj5MJXc5pu3L+cKO1XKrrcx6=gr8W_874sYPzfnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4PR/+zdSfVlxyWed"
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtTtYzj5MJXc5pu3L+cKO1XKrrcx6=gr8W_874sYPzfnw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--4PR/+zdSfVlxyWed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2012 at 01:44:07PM -0600, Steve French wrote:
> Looks reasonable.  Was this found by static code analysis?
>=20

I saw this in reading the code for something else.  But it should be
a static checker thing, definitely.  I'm writing a check for that
now.

regards,
dan carpenter


--4PR/+zdSfVlxyWed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH7AoAAoJEOnZkXI/YHqRYWwQAKO4YzJ5IlYA7fkQlscjH15M
I/07eZG/Pwf8tner4L9YW3Pe0f+iKjZG9XgwUzqyYeSgUrNh8d+8OvZ1NNcrR3C+
ywfpc/AQOhMba9NzNWX61r38cwRXJk+DGFHN2w3tbHpmoXszIVomMUNFTzXJQ1S5
Pzu/7b5vbZ0ERFbdpp+pUWcXTB98eBliU6WE8RJHMpwbM1ICrcCo9wjbn84nruNu
y8ySJJGoX8pdYXfV9rcetNLsiKEHiiU69QOZp5bx9s5XMt8dh/iaOrJYslWyWu0/
NgFmbznNqUz4zuYkFR/2+k/uhLdC0yF0Mxb5qiVItQkZeVf2ZCMekdOZopMQPq5O
3xaoAhGu+Ne8oDgn85bS1n5etY1L352RN6SLz85SMLvHoCDRsQgGBzlZjUgg2Twm
CD1pMlV9e72WbwSaLb5SkCQrWU9AunCkPNTn+dUJRmaHAnMZrkCjP3te61aXJMH9
4/FPQf7N33zsEa0Z811G6TLkJaLF7mHnJD1QguWWHUAbhmcT561FuK9VhuLOOED/
HijzKJR/68l6K6iweGIxJ1J47HPPUGHPGZFunkKavyHsIU0o18eR+tP1dx/8i2ni
P9vGZ5/qZM9LrCET8VG94Gt8LrdPzrAMUDEIIg66vAb8tckVGJrNy9+23xFA11EG
V8reo3NVbAI+8i5phQX7
=7LQE
-----END PGP SIGNATURE-----

--4PR/+zdSfVlxyWed--
