Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C061A23B1;
	Thu, 16 Oct 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760637368; cv=none; b=Bve1mzfqic/qTP44wK4eE5v9hEbv/MSacFj7zPrha86HkFrY5oynw0w+/DTHCvbg3lGaJSqinGrUNl4HQmEMzoRoV5yTJfeeP+8aMZZPYjWhGfjO4SKDZdi1xM4W0yxcZibhztXrboxetsyIDqvHHbbYfHOU6vGziPNWrgnXXyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760637368; c=relaxed/simple;
	bh=t41Y9VDhNSNMHPufaEkfURdHldI+e5QpdgeHRDY6BHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8+ICTv5z4TXTYMPxKIV5hzC/ARmFWNLQHzWPREtCua432p09nMzjoorIkPMTPpeUcAya2ekwV1Zy3ZWptJ1c7VZYr8Ww+LQl1athyLMdsFcL16hRQbEqFiS5LKDZzqxOdoDK3vXBsjlh0k++6J2JjIQxlH91fDtQqcmUvw7Fq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XlnJqwHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XlnJqwHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A59C4CEF1;
	Thu, 16 Oct 2025 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760637366;
	bh=t41Y9VDhNSNMHPufaEkfURdHldI+e5QpdgeHRDY6BHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XlnJqwHqx3tbyUJr3lqmmLELFQ9LvUIBII01InaYExifzfJgNXs0101QC6bMV4pyF
	 os8auRKo0dbB8Xt8J6nU07mI1c0Shz/drhv+/cFzlXMXSFYJTfepTH5No0PfwVaMgX
	 EUv8xyIJx5YPX+QLXVqlRhlez6OyrKXQPbCwngUfIH76cg3PncFpK6qRdjaXCFPBiL
	 4KHoIDQH1jSKD3HauU88eEoxJAup10PsYUpyJNVA/gD08a6ZpyhoQAUzPzjxADEFqE
	 kcmZ952DtlRXNjvxQrHdNTYq7tTwDYjOYM3FlKJUJpd7r1qvcXrT/cnReupBtteI9a
	 d2LzS0eRcMwzw==
Date: Thu, 16 Oct 2025 10:54:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ksmbd: Use HMAC-SHA256 library for message signing
 and key generation
Message-ID: <20251016175433.GB1575@sol>
References: <20251014231759.136630-1-ebiggers@kernel.org>
 <20251014231759.136630-3-ebiggers@kernel.org>
 <CAKYAXd8Zwnr2bv85_xEekjOHvSqC7dtfZw+ETZnv1s_d+ZRyiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8Zwnr2bv85_xEekjOHvSqC7dtfZw+ETZnv1s_d+ZRyiw@mail.gmail.com>

On Thu, Oct 16, 2025 at 02:00:37PM +0900, Namjae Jeon wrote:
> [snip]
> > @@ -8876,22 +8865,21 @@ void smb2_set_sign_rsp(struct ksmbd_work *work)
> >         struct kvec *iov;
> >         int n_vec = 1;
> >
> >         hdr = ksmbd_resp_buf_curr(work);
> >         hdr->Flags |= SMB2_FLAGS_SIGNED;
> > -       memset(hdr->Signature, 0, SMB2_SIGNATURE_SIZE);
> By deleting this line, the following error occurs.
> 
> [162118.260693] CIFS: VFS: sign fail cmd 0x3 message id 0x3
> [162118.260707] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.261473] CIFS: VFS: sign fail cmd 0xb message id 0x4
> [162118.261482] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.262437] CIFS: VFS: sign fail cmd 0x3 message id 0x5
> [162118.262449] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.262892] CIFS: VFS: sign fail cmd 0x5 message id 0x6
> [162118.262900] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.263301] CIFS: VFS: sign fail cmd 0x10 message id 0x7
> [162118.263314] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.263724] CIFS: VFS: sign fail cmd 0x10 message id 0x8
> [162118.263736] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.264142] CIFS: VFS: sign fail cmd 0x6 message id 0x9
> [162118.264154] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.264591] CIFS: VFS: sign fail cmd 0x5 message id 0xa
> [162118.264603] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.264912] CIFS: VFS: sign fail cmd 0x6 message id 0xb
> [162118.264925] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162118.265244] CIFS: VFS: sign fail cmd 0x5 message id 0xc
> [162118.265257] CIFS: VFS: \\10.177.110.57 SMB signature verification
> returned error = -13
> [162119.831575] CIFS: VFS: \\10.177.110.57\homes2 SMB signature
> verification returned error = -13
> 
> I have directly restored this line manually and then applied this
> patch to #ksmbd-for-next-next.
> Thanks!

Thanks for catching that!  It looked like zeroizing 'hdr->Signature' was
only needed for when ksmbd_sign_smb2_pdu() failed.  But it must be part
of the HMAC input data as well, i.e. 'hdr' must point to the same memory
as one of the iovecs.  So restoring the line is fine.  Thanks,

- Eric
