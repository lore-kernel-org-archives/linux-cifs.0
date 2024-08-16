Received: from mail.hotelshavens.com (mail.hotelshavens.com [217.156.64.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D141B8E82
	for <linux-cifs@vger.kernel.org>; Fri, 16 Aug 2024 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.156.64.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723814464; cv=none; b=twWJODHssPhCdaAR4rmSgzq1r/L2Nhtg0WMs2dJhgyikOEzW7rT5EbwYL0N1aWK7fLF5Y1lzqAz+Rxv+ZnMw4CeItNs7u6gOkmAqDv44g3SybNFmAah0iKcmPj5rL5vjzmZvXf4A07FUJbzcWdVPn9sAi3oDy6mKLxqKVkdlz1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723814464; c=relaxed/simple;
	bh=TwOOHn1542hY0lrSQ9+9rOpOV5UpyxZx7Mhexv1Vf8s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RAyUcD1RmlYVkffv2hf9NsPbSlhjCWt4d2/TV5fnvHes/StEInoYCZ0ZhO8rEL37KnWKs+6/NwIgmz5EjYz7o+hr4QPxBECxnYDBsIoVCihEF1xgzz2tnN7C9xiJ4gHex/tW3oQzukZBNO5vRLK4G9EoU2tFBdCKhSRqjQfRc00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotelshavens.com; spf=pass smtp.mailfrom=hotelshavens.com; dkim=pass (4096-bit key) header.d=hotelshavens.com header.i=admin@hotelshavens.com header.b=RTKDsXWC; arc=none smtp.client-ip=217.156.64.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotelshavens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotelshavens.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=hotelshavens.com header.i=admin@hotelshavens.com header.b="RTKDsXWC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=dkim; d=hotelshavens.com;
 h=Reply-To:From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:
 Content-Transfer-Encoding; i=admin@hotelshavens.com;
 bh=TwOOHn1542hY0lrSQ9+9rOpOV5UpyxZx7Mhexv1Vf8s=;
 b=RTKDsXWCYDeGlJKEkEt0HUXNz4vD4ARkOkyt2fdK6m7AARGmDYDF/v6fIChtetz5fkoIAwGZClkd
   +2hrdZc5cDVM78vAdc8TQSJkuyI9OkQ26xVSvNclz1IkPVJSzF/XhrO7a+QLKSHnKvljrt5QxNJr
   CAkPosmCUiazJDqlI/XLmrwQS8w11Dc8k78WZiMC23eQRzEh4+xWcv0yPLYlr+AFJU2wASsmpUyX
   hfHHCBsvxfNg2xkzSWTOKNHujIiTdCXT7YLMu7+4Ko3QWETIej3dL1vhF7UTCzUlVKb6NiE6PRk4
   Lgrawki63pgd2AfzxAI+JLdzG5ZcXZhuSTPbhFEwLYqAZxScSYVLtzcseRDXLEL6sTeYTvR7IjTy
   vhAnSxgzRQLABIEnWFf7jFxs8lBPyDpjfLR42b8t76uGXFsl133UQK6KUm2tXNNSwtVw8itP8AZp
   iDKF62mW+omhrL6VF2j7Z2WX61okW9L8BsgW10chnjRSbDSXxK/11rA3V1vpL5Co59I440TCQXQt
   L/SxTZRGzVoiTnALFE2+3SKJd5jSptcYDJVDKuHNhtxHWBOUIxWqMmxB87G2W4sSbILzVK6DgY7V
   k9vo7TKYPd14gtFMeWJQOApgYWid0qm06UsB7a4aLsm0O4zROCRvqdHymouJCCYkDG26ztchEQI=
Reply-To: boris@undpkh.com
From: Boris Soroka <admin@hotelshavens.com>
To: linux-cifs@vger.kernel.org
Subject: HI DEAR !
Date: 16 Aug 2024 15:15:39 +0200
Message-ID: <20240816134828.B57B17AAEED83DA8@hotelshavens.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Greetings,

Did you receive my last email message I sent to this Email=20
address: ( linux-cifs@vger.kernel.org ) concerning relocating my=20
investment to your country due to the on going war in my country=20
Russia.

Best Regards,
Mr.Boris Soroka.
