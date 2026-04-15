Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A08D335072;
	Wed, 15 Apr 2026 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776249826; cv=none; b=dB3uM90VQhqaUVbf0YXBOYPVYuMLJv6DulOWE3yn7Ki+ZnpVeMh0nlTgX9zbeTFv97NzGBq65QJiyRA3gpIvez3YI8uT671Ym3fsgp8SEOecpI2YRY2yX3za6ELDLA+cTxfTkPiY+GIC6RDXAg17JMegcAALUKUtG+lcIYE/ONY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776249826; c=relaxed/simple;
	bh=Sx9PCLygQY86lCuAtZCgpuiP224THQSkn/oeVKEBiPs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eAc4PCWXfAmU64V27pa7vop+j+OIRIKwV6rF3kzyHBsbJxO8bHBwYgCQpC7JtTNZGqTmVoYZqjAQXHFl0cMojOHfs5TtRvwRsG/MHlroa7Zb1K4PubtOoVRj3Ez5B/fKFFYoDzFs4kVvRuzVDJZDHGrcLifaVWYxEskFnFMRU1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnyJKIQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnyJKIQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED729C19424;
	Wed, 15 Apr 2026 10:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776249825;
	bh=Sx9PCLygQY86lCuAtZCgpuiP224THQSkn/oeVKEBiPs=;
	h=Date:From:To:Cc:Subject:From;
	b=VnyJKIQE5vQapRfleyPoA/W0IiMVQF8m/aQZKvkv4fE7hcIcMNroJYxbwqGI0GRRQ
	 2I07nNTPliiqKBnfBeWwE7CbmntGQiD2qetKrgPftcvV484T6q4baMqlWk6LjU9z+C
	 LntPXfrLgQSlfVZoE4sIIRu6zF+THRbQpGi9C4inK+Yg/wFxo+tEVaF2SmCUdpXXg8
	 zDOd43Jxr7xtPqYdC4DjLjLHFwKpJ4LVHLx+svVi3RemZEQj887o4lIXsPcGeuzCmI
	 jeWbSIZ2AHy/5hAQ710fyCtzEudE4J4ivML6NyM7ZqAjl6q7NbKTIZKku8/47fdE4c
	 9fCqeNnB1cSDA==
Date: Wed, 15 Apr 2026 11:43:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the cifs tree
Message-ID: <ad9r3jEtJJNv0IiA@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VFqcEjmKTI05v9Uw"
Content-Disposition: inline


--VFqcEjmKTI05v9Uw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

After merging the cifs tree, today's linux-next build (x86_64
allmodconfig) failed like this:

/tmp/next/build/fs/smb/client/smb2ops.c: In function
'smb2_query_dir_first': /tmp/next/build/fs/smb/client/smb2ops.c:2655:70: error: 'CIFS_DYNAMIC_BUFFER' undeclared (first use in this function); did you mean 'CIFS_NO_BUFFER'?
 2655 |                 rc = smb2_parse_query_directory(tcon, &combined_iov, CIFS_DYNAMIC_BUFFER,
      |                                                                      ^~~~~~~~~~~~~~~~~~~
      |                                                                      CIFS_NO_BUFFER

Caused by commit

  3777ce7e53f80 (cifs: optimize readdir for small directories)

which really doesn't look like it's a fix - please note that we're in
the merge window and only fixes should be being added at this point.

I have used the tree from next-20260414 instead.

--VFqcEjmKTI05v9Uw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnfa90ACgkQJNaLcl1U
h9Cdwwf/S9KkEBlV6I1v71C0jXc/PmAsZlF7XUy4Z8sdT0q6dV+s+6Ejv7rfIuFH
EBRyLjm8AvewiQG79oGcZZdQ+FljMOM1W7hqPPlM+BJuOImyfTyTT7yHR0F3qucH
tSew/H/M1Yq4M7RtV3JQrTWObotKiVoDdC9BOg0TGBw2eFIhDfvb6qidu4+eX6Hz
9iD7Sr81GuwynY93Xn6uayflz/+yZ/ZWqXT0s6di1ZA2Jgt4Z/TeS4QCEWVGQx9n
C67uKBuV3MyvgleUEqz7xtCwVxveAzaC9Re4MkGEo4nxlMd+hhlak2swOHY2suF4
dAe6y1XGQDgrCAe1QEzpzJpqyHjH2g==
=mbBz
-----END PGP SIGNATURE-----

--VFqcEjmKTI05v9Uw--
