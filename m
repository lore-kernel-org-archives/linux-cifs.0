Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6790C2BEC2E
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 23:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783554377; cv=pass; b=JIB+xMU0khP4w1VTDX495wFIUd6MVUsod49Hnf/XpUkfW31yLkQTuOV2lfbcQH8jUdGpHXF5IhpR9wAAZ2KqWuB0P2z2qornOFVGXKRiavxScrpWi2ISB3RmefHLa4qVTReRNJ9HhxxPvBlyHAdEgBBbOErjnPFDTSdJtUOn0OY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783554377; c=relaxed/simple;
	bh=bogTf9sKA309KZfQOo05YPNzqJJEanTlOfbP/mni1YA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sxcbzNrK6RFTuncvRz4You7TBc1ATsJfpaBOc71LvuS8cTQkVsbs8yJpBxI6hwpGmihQH992IhQRLFWAYzXTYVTDeayhUMjyeZtxRFdA3LSP4NCOY4+3Dke8gxz98Ymjpz4B5CAjDv5aJtnjYzobwa1CEzII3aXir9DvRybn+Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dv8MrqW2; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dv8MrqW2"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5aeb91c003eso1311424e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 16:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783554374; cv=none;
        d=google.com; s=arc-20260327;
        b=sr4+amTWJH81mTFCrvpTlXn/qmMgBFlfOkLBYlxTJj5rnFAlYlPfx7+NvsVSuji+q9
         YMtRb82wo0X+WVy224iAJ4GSgUQJ2OQTWYpePIimjNGzP0sVOjDInIy6Y/NuwTHtgWc9
         YY5tUkvLQN0kvTkM5oGjZwl4lyyscGO2PqgWVtJvIJhpCB5sQm3v3q4Hbc3YbnVl3ex5
         G2KvwZXpIs3MCoMzizBRyCUiCtzmMMtfZpbs6Xwu6JrPZnAMl259RzUS/E5V+COy7zYl
         eWYY/eQBuSwLfcvBnK9njvvzqQI+DecPjLME21e8Y+tVVkLi1VbtmaxBTDuit3u5GEa9
         Y7IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CcUMwXmEbA6CGGG/L3J6rC9uyengfo9qTR4Iv0cdbrw=;
        fh=X8hSpa99KKiLyGbYuwkbFGyi4ceGCyGC6pUF+5adBY8=;
        b=iWj/vcrfIhHcDERsulqZrdn9Fgj3X27NVhelIrabLt2cm85PZNj2SbxeIKvgFZjegq
         DJYaDhjOzdNNzVndgb4NawGrA6Lm6tnyPGHoXO7hAFIa9JJJ8kC+exgRfh0e6HVGxzKj
         D8qhUPeBMr4QlQcpIG6UI98MAeqDW7kZfPVTU/VTXpUJBhJt8Y7+aYHf1pu3WqbQnNvc
         fh6hOJ0xbyVTy4AISjS9O3sLsg/ZmCtSKLB7+nJLDJY1z6cpJNrFZqt14ZE1SplJ1r3A
         CiSQUmKQ5HoV0A/F0lVwr15AIbMAGwjq4fhRkiRdUt5nmc00NopzdCAeMM1FohVHIR+e
         QSCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783554374; x=1784159174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CcUMwXmEbA6CGGG/L3J6rC9uyengfo9qTR4Iv0cdbrw=;
        b=Dv8MrqW25nSn6qvw+z+c0ryeqwkovHWxSFqqFmEeJqlEZ2Vh/kE1s641LyvLb+jflR
         GsNJ6pH/rxm+Fhmd+dPM20MzfRphWFK7AjeMemiaZ/kBIrNgwc5k2m4HOXBHC17Pik66
         dahc21h2hgg/BmSyU5YZt1oP4t5k/+V/5wAnREdNiByGF81X73oQ+FheuifaU3jB9foi
         KwGw1ztMcd4WLB2l/5KYRLlDx20GLLJSTs8MgHoJpoK1t8xYBkbtH9J4wUFExjDXKzwX
         BjOcrH3r6N3U3id3YRV0M2PAuXBIPhm2pSyMEUKx+GZ1J7BQUsRcfO0qYn+O9pC6xO4o
         FjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554374; x=1784159174;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CcUMwXmEbA6CGGG/L3J6rC9uyengfo9qTR4Iv0cdbrw=;
        b=jh4lSiTWNVWA6jZr2fhYJfDizzEUdm9hTm+f/ztfYPMBNUpbidaU9gvO8Qr5xR5X0G
         K+FpX3vExssSrLldKcG833V+PnITl6GPPwcHciUqn4SGQ+9tnOLdETwWYdWWtvvV9LgA
         6o7RDhOoKLVpCE1hPRrhdvQFXtDrpC3VOJaE3rr7C7Z8KAqsxj2T1hoxUI5yR4CdfpBA
         z8t6RGOxIbyXNSmL7xzZxlUTewq4Omfd/wefUI6+WhedLsc7sSmXa+TuPXEYcJKIfABq
         z922OqxM9JOQEw0W43szLIf2XkHlIZmyZN5ZwNG/rawa37EtgEXOwGljctziMbobI8Wo
         oF+w==
X-Forwarded-Encrypted: i=1; AHgh+RrSIyVoUCHNAYjkZ/QXCSPjW5vtEBf+0424IZYjcaly+wZWKr29sX6j9opTJcxdgpJbZ6DqPWIdTaSB@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4YikmkoqVhqZxhCZV5kMZ9mVWWfTTqmaoqzWNvZAcDpFCuuqN
	6VHWY1jtcKGQz9fOpQ4RixJrxvtDFiNiqfdLYbjpiU3azQEDKR8dScocaxDM/6f9qMzsPA92m0B
	pd5tzXVAwPfK9xmtZENghlaCLrcZiPPBFP1Xw
X-Gm-Gg: AfdE7cnZuDSywc+kmIPm57G8cMHhKxjJANG3gyvjg6LhHVzIBVm61kvrSnJnM5RMPfV
	TiQ8/9u+Le4hMda2tJIW9F6vc67lAUPn5wmSCgrAR//ojE12F28TyGroBT7/2IXVelQBmEHWq6x
	pXiQLcy0s51IB4Q2AXQCifB+FWyMSvDGUrBD1dTfgjYWkB5iuLf8+Yy+LQrHeWOOnJ7cE52CNq2
	MNXmYuER+tNaZzeiF6ArSIOo0AsMqxDVNlM1XTQzGXnyLYVntWABhzkEdoTfIGLgUyIqBYaoPSC
	CKMVYj1x1Pq29TSah30ypTjSqw6PcV94BtNU5telALJwEORhughroQjwHBrhB5CaRI4lAT6k5vf
	eBKQBlzl3nwKJZOekhGhKA5RApiUi3O5sHkNOEAQf9H7N+oxvFp9V0JL9yl+E9mQmESe1CpKK/p
	7JmIoRrZE/o44=
X-Received: by 2002:a05:6512:641c:b0:5b0:eda:de2b with SMTP id
 2adb3069b0e04-5b0114906e4mr980344e87.50.1783554373413; Wed, 08 Jul 2026
 16:46:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <527C2DB5ABAE200F+20260707133017.1740557-1-raoxu@uniontech.com>
In-Reply-To: <527C2DB5ABAE200F+20260707133017.1740557-1-raoxu@uniontech.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 8 Jul 2026 18:45:37 -0500
X-Gm-Features: AVVi8CdYvG_0J3hTjQC5XD4i5qJ62VPNYGj58VfdHkF8ve7UCf11kH2BklMa7W8
Message-ID: <CAH2r5mvfhcz3iDmRmgyQHpPeVtdfHdX_Ah1KT_+TQtLECqgaHw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix atime clamp check in read completion
To: raoxu <raoxu@uniontech.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Jul 7, 2026 at 8:43=E2=80=AFAM raoxu <raoxu@uniontech.com> wrote:
>
> From: Xu Rao <raoxu@uniontech.com>
>
> cifs_rreq_done() updates the inode atime to current_time(inode) after a
> netfs read.  It then preserves the CIFS rule that atime should not be
> older than mtime, because some applications break if atime is less than
> mtime.  That rule only requires clamping when atime < mtime.
>
> The current check uses the raw non-zero result of timespec64_compare().
> It therefore takes the clamp path for both atime < mtime and
> atime > mtime.  The latter is the normal case when reading an older file:
> the newly recorded atime is newer than the file mtime.  The completion
> handler then immediately moves atime back to mtime, losing the access
> time that was just recorded.  Userspace tools that rely on atime, such as
> stat, find -atime, backup tools or cold-data classifiers, can therefore
> see a recently read CIFS file as not recently accessed.
>
> This is easy to miss because the bug is silent: read I/O still succeeds,
> no error is reported, and many systems either do not check atime after
> reads or mount with policies such as relatime/noatime.  It becomes
> visible when a CIFS file has an mtime older than the current time, the
> file is read, and the local inode atime is inspected before a later
> revalidation replaces the cached timestamps.
>
> Clamp only when atime is actually older than mtime.  This matches the
> same atime/mtime rule used when applying CIFS inode attributes.
>
> Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xu Rao <raoxu@uniontech.com>
> ---
>  fs/smb/client/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 58430ba51b10..62605928d2b8 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -301,7 +301,7 @@ static void cifs_rreq_done(struct netfs_io_request *r=
req)
>         /* we do not want atime to be less than mtime, it broke some apps=
 */
>         atime =3D inode_set_atime_to_ts(inode, current_time(inode));
>         mtime =3D inode_get_mtime(inode);
> -       if (timespec64_compare(&atime, &mtime))
> +       if (timespec64_compare(&atime, &mtime) < 0)
>                 inode_set_atime_to_ts(inode, inode_get_mtime(inode));
>  }
>
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
