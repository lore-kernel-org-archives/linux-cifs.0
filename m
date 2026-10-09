Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9892F45D1A5;
	Fri,  9 Oct 2026 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791574040; cv=none; b=GUqBKsd58VlrH5ocyL4ffEHOnsN3J7ojPXKdU3spobUaJfbs3gi2zf2iZCPJFmNAuiKtGsGiv52wBwRQIAYVBHwl4StyAnfhCormkrFrBzRQJsbw7gRkZsQrapG7/bEy9kgQMo2rAd28SpaW3c/jpD/zsFqLcgnEAQI1daIQD5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791574040; c=relaxed/simple;
	bh=IIJt4GhnfKUZ5ZMrdUlvqukXGauHWCP7Z0q6PeQG2A8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pAEBbm4y03fz2Ath9JGsK8wxoEtb3yJSMDX3U6Y7cYmP9w9k0+0d0x6d28eSf56BE1b4vL700vFAjcnnmt9YS/Pg+MpfyWH1ChmANSV+bxhi+gLh1Uy0ryxX6f/HEQrpLGvHqUhUt6r/Pnsuru+KK+uRt9/aByhAzYRLH/gho+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTvx0eJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTvx0eJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C31F000FF;
	Fri,  9 Oct 2026 19:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791574034;
	bh=svaNQnV25Kh9KTrjtDpU1B43XeKF+ZRj6anUbIjpMYc=;
	h=Date:From:To:Cc:Subject;
	b=gTvx0eJ6NAyBlsMTfbLVZ6Whr0Lc6fvey35uYQQ+SCDe0Ha8eCCAFKJqVXLgOtKBc
	 B54V20b2fS0SNt1eFehRtk40kGUI5IEk739zq9qzyS+h5T1NwLC2hNUVbyiHyvGmVI
	 q7lVV5Jt5w+hrPL84Vui8hJ2xdUtJ/KJliWuHgHs2d9OjWY5p46I2/YkOWipmQsivd
	 8fh49ETjKdQ5vGfq49pc0lUsfXlkl/cRog52pBwTC4Gv19KHHZSuJwTfusKR1LNAFj
	 PEHro3TTPDDi7xpTvOH46KqBzvR04g0sNFTmf6vv8bTBD52ozN/ra578aDC5Zm95Mh
	 7G7cVkvDQRN/Q==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 56F691AC57D0; Fri, 09 Oct 2026 20:27:11 +0100 (BST)
Date: Fri, 9 Oct 2026 21:27:11 +0200
From: Mark Brown <broonie@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Enzo Matsumiya <ematsumiya@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: linux-next: manual merge of the vfs-brauner tree with the cifs tree
Message-ID: <aslAD9CbIfMrpKsE@sirena.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4y3Ow8CUVbJPpJv2"
Content-Disposition: inline


--4y3Ow8CUVbJPpJv2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the vfs-brauner tree got a conflict in:

  fs/smb/client/transport.c

between commit:

  fae67a14b8d25 ("smb: client: fast fail sends if need to reconnect")

=66rom the cifs tree and commit:

  d0ae35565f5d5 ("smb: prevent TIF_NOTIFY_SIGNAL from interrupting")

=66rom the vfs-brauner tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc fs/smb/client/transport.c
index cf11af490b0d8,93ff6a4dbb350..0000000000000
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@@ -171,26 -170,11 +170,22 @@@ smb_send_kvec(struct TCP_Server_Info *s
  		 * after the retries we will kill the socket and
  		 * reconnect which may clear the network problem.
  		 *
- 		 * Even if regular signals are masked, EINTR might be
- 		 * propagated from sk_stream_wait_memory() to here when
- 		 * TIF_NOTIFY_SIGNAL is used for task work. For example,
- 		 * certain io_uring completions will use that. Treat
- 		 * having EINTR with pending task work the same as EAGAIN
- 		 * to avoid unnecessary reconnects.
+ 		 * Task work must not abort the send, see signal_pending().
  		 */
- 		rc =3D sock_sendmsg(ssocket, smb_msg);
+ 		scoped_guard(no_notify_signal)
+ 			rc =3D sock_sendmsg(ssocket, smb_msg);
 +
 +		/*
 +		 * If need to reconnect, blame it for any non-interrupt error
 +		 * and bail out early, even if -EAGAIN;  reconnect will never
 +		 * happen in parallel as cifs_reconnect() needs server mutex
 +		 * (which we're already holding), so it's pointless to retry.
 +		 */
 +		if (unlikely(rc <=3D 0 && !is_interrupt_error(rc) &&
 +			     READ_ONCE(server->tcpStatus) =3D=3D CifsNeedReconnect))
 +			return -ECONNRESET;
 +
- 		if (rc =3D=3D -EAGAIN || unlikely(rc =3D=3D -EINTR && task_work_pending=
(current))) {
+ 		if (rc =3D=3D -EAGAIN) {
  			retries++;
  			if (retries >=3D 14 ||
  			    (!server->noblocksnd && (retries > 2))) {

--4y3Ow8CUVbJPpJv2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCaslACwAKCRAv73Ows9A4
iaMzAP9a+P7RdUoznGKPzU1e3Og6ddjgB3xC0+5m+R+Vt1k6WwEAhk4zwXM+QC4F
JGdEKBi/j7vmW6ksy+rNVi+kJviC4AA=
=PczA
-----END PGP SIGNATURE-----

--4y3Ow8CUVbJPpJv2--
