Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B4336AB6B
	for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792315126; cv=pass; b=YireHJRj+F9njQZgdYXxABj85NBHJERcOnWlcaFLMdBF+4aws6SXLiFS5fYx0rmArAOOcfDrjTMiUY3MH0C3WPmRlwcb8q1w3OgcruCh5I9BDyZInfNRQUXCEsv2QjVhF8luLgG02PbeBMlc5Gv/aZ4Eyzk+IA0XevAZEn88Kic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792315126; c=relaxed/simple;
	bh=Hl9knlG4/9ywK5hPuGY9eJmWuv7uoveTetSEz3BOFyI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nlrjWwHMOE5skLkJ897O1OI3sDXi8/VhOAcV2a3EFGMpS7dTaP/zAdWVqHSYrts6VDMGklr2bzfeHP14gqsz4+Wwgariop98AYXp5gTcdy0i3h+IQlsA2yodISEqlNsSkGx+krKBxowwacUMraLrceKQjex9kGAriHG8jNS6imA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=safebreach.com; spf=pass smtp.mailfrom=safebreach.com; dkim=pass (1024-bit key) header.d=safebreach.com header.i=@safebreach.com header.b=WYyA6iHw; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=safebreach.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=safebreach.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=safebreach.com header.i=@safebreach.com header.b="WYyA6iHw"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c434376dbebso46372966b.1
        for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 02:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792315123; cv=none;
        d=google.com; s=arc-20260327;
        b=PtCEFVBfCHpYbMsaJQfMWeBBdKwul2XIePq0cAy+FlHQ4mGUwvXTBn0GAdmlL991mA
         6dzGfEAGcGzhZg0V08YDUlQTkJyI2ADTXOqPVoqQVT84pT1WWF+JdKa8bN64ezWNM3dN
         xLdXH9/CQAVhYuyKirbdXb7gv6Qc4TC50DLVngd99Ph/BVJM0yAjnJVy/lOEOVGJl8mu
         Gg2WoJfO/v2vAl2JyPFZ4db8MEwhN3K/u7BMTIWmwv5b/BA/K/50DVIFOc2RlGSQZMQ3
         okAfgtkA1uHE+1qXP9brP+x0X0bv+jX/bqcvM4EGe+5S6PQmNFbRUAYFKc5g7BmpiQ6D
         Hi8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=H/fFhaq2RFRjuIvCWE9nRJGfxKNKEB9NeriN24IeNGc=;
        fh=P3UluCj88NwkXz2slhL2SyOd7gJcUKwxpU9LBu4edYs=;
        b=qeNUoiOYqGYv/n32QMF42PKpY5hRx6a1k4TU6jubJjm7kRaJkDGj5Wx5mn2vUgoWHj
         FQGeH5YCZMwOzNAaAS2/TnRnyWXZ1jvOizfkweCExUx+b1+zHmqISE0PeeT8/gJmN4hu
         etaTeo/W289x1qG0/+A+9nSOoSuXhMIacNNEa3K6uURhsr20SDV8IeecXCaMY9VKodB2
         2jMNJ8RYV7b6mxGGXGHslksfaeOL/biPEF0dihJdjagvWHeO+IbJLR1NQJAXvF01flsp
         7Ca19Ix+/hdlXNksJWtOgPkOtK4KzE2cJXrJ4p/fkT3NS/dxKCLIcV6Ee6feLQq52gq+
         EqBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=safebreach.com; s=google; t=1792315123; x=1792919923; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H/fFhaq2RFRjuIvCWE9nRJGfxKNKEB9NeriN24IeNGc=;
        b=WYyA6iHwPQldnN7DhtEGHoumn+wcB9Grt2p1EM5JOI+QxQaByr/aKxtOmxtf99lqqY
         3ETLBXWSR5Bx97KxNMi38A3uBWLPz4MVSbFTfakyPAqNUI5C0UeVI7YGVPAt+OBMkf7T
         aruvLT88LHxnF99JuASAXXD3BK7J3lH86vkps=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792315123; x=1792919923;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=H/fFhaq2RFRjuIvCWE9nRJGfxKNKEB9NeriN24IeNGc=;
        b=blrKxe6pBZfDgJceBFuQRvTFPkT1T4+4EkW3kpne/Uqa0dqJxAhgsA37ImoWNmi3rf
         d4FFehgvd9YuzwmGTlw6NTueTlghZMaMT4tMFb40uRgbEBm81xEIZlPjC5calxrEvKXd
         HHJZu8UIsOBUSqfiq19jaQqGGFYJ73nyhFS818dAiGsVijeVjID44ot/jZn55ix5SqAf
         nENuFtfmu8A5EO4f0Z/rwHl4chRpO80ICbTmk5f8Po8dxWy9aBtFvu7gWzhfwG9ESz4M
         1T+bZAZG1tIzuonjAPZ6ik+mCpB4a+NQpGr1D6O6wAMuiM+o6angvy79jV2aMATa50mB
         u57g==
X-Gm-Message-State: AFq9FYKiWrieNmRdEoJYJV0AtRQwd9de7xyIqwaJdutH1WxlIC5SceTl
	CjeIEb8v9yjXaSd+jynHIp0eahNNy5Ji45XbNqK1O6yoB53Awuu4cG9Pog0djmEh/F7s5sBN34n
	1oUcot/oonxA8cTiTQYEHqqgImRwGghbpIwVkP2neug==
X-Gm-Gg: AYBFou1MCp0iPnhJligUq52d2HqEKs1yhqqHHe5bhMkLPefiiC6u/uCErksZiQ2ApZH
	udhSq+imm9FpPfsp40vPO1HxsXwe8zpjSeyQbzPUzcnOWMm0VvzR6w/qagQoIu6c5W2KClsvXBT
	UM42QbFl46ZqQRWO/+h+d8lvn0Gi7IvsTU0808a9hftJhBnmIYq5W8I8BFvBFU3Vn5qbdTrcA/3
	fjLcbdYR/kpl/gXYP4gaZnIXgifWOC52sk6EdvV085o6OtCGZR00Xi1udeFEoSCGJXaWLC4GNUM
	GjyzZjBFL/VtTQuQxB0MqszoLotQraOLZMbfMgA5oqbNWz38H2ICCWM=
X-Received: by 2002:a17:906:9c93:b0:c2e:204d:9490 with SMTP id
 a640c23a62f3a-c40217bfed6mr616038366b.17.1792315123134; Sun, 18 Oct 2026
 02:18:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ilan Dudnik <ilan.dudnik@safebreach.com>
Date: Sun, 18 Oct 2026 12:18:33 +0300
X-Gm-Features: AclHuK8jBpd4fOYBK4rGGeRadJy1WR4qtfRkepjNBzPoZfIt3xn_lQ-UjczWrcU
Message-ID: <CACdWfbyqY_rUJ_Qj0HvuHGEb-PBjwj6eKYCY+r1WZtNnsWuhiw@mail.gmail.com>
Subject: Subject: Request backport: ksmbd: fix heap out-of-bounds write in krb5_authenticate()
To: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi stable team,

Please consider the following upstream commit for the stable trees:

  23a0be6a84a3 ("ksmbd: fix heap out-of-bounds write in krb5_authenticate()")

It was merged in v7.3-rc1 without a Fixes: or Cc: stable tag, so it has
not been picked up for any stable release yet.

Why it should be applied:
When SMB2_SESSION_SETUP is processed as a non-first element of a compound
request, krb5_authenticate() computes out_len without subtracting
work->next_smb2_rsp_hdr_off. This overstates the remaining room in
response_buf, so the length check in ksmbd_krb5_authenticate() passes,
and memcpy() writes the Kerberos AP-REP blob past the end of
response_buf into adjacent kernel heap memory. A remote client holding
a valid Kerberos ticket for the server can trigger this during session
setup when ksmbd Kerberos authentication is enabled.

The issue was introduced when smb2_sess_setup() started passing the
compound-offset response buffer to krb5_authenticate() without updating
the out_len calculation:

  Fixes: 98422bdd4cb3 ("ksmbd: fix out of bounds read in smb2_sess_setup")

Kernel versions:
98422bdd4cb3 was backported to all maintained stable trees, and the
vulnerable out_len calculation is present in the latest releases of
7.2.y, 6.18.y, 6.12.y, 6.6.y, 6.1.y and 5.15.y. The fix is a one-line
change. On 5.15.y the file is fs/ksmbd/smb2pdu.c instead of
fs/smb/server/smb2pdu.c.

it's a resend because the first copy was rejected for HTML

Thanks,
Ilan Dudnik
