Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6423568E8
	for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222871; cv=none; b=k4w5JRZcFN1CKUAaQkhRC3fisWJJOZoznOOMxNWuOVMPVqIvn51MY4F/yhex3TiP10YvpfxAwTSX9LpmKq/NWEIixD5qJwiI/du9eobIbm414Is8H56bewrJi+DEoiSmC8HZpTOcnDAVVvY3wZYYx/cP1cPzAJj0wcam/+vHHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222871; c=relaxed/simple;
	bh=pEp3IJXmmCTgNdYq9GBP+pw7hhtQPwM3/c1PJBTV0XA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XRyVXwtVHbjjGVrmY9WJRwlwf6Ry1E3VRsU1J6CJsb27Puo7duCLAML5129YxZvavsr2T9+2be79isTW8s4PxIeE0gcW4lZRE/9hdQ4VsXBOqNDdy/CHK/GQatEPSerioMQdKDmf2o8qc2hMPF5iqwEG/HNcm96vgmz/z9FNHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THVl6cg8; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THVl6cg8"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e8704da966so392824485a.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756222864; x=1756827664; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S4Qxtfh0XTA1uBqaz5CYZj55f9pkrEroKUb8W6Xu5Gg=;
        b=THVl6cg8hQ+ckynsSnnColpygqVTOUcrj3LQjzutaJhUJlYRFJ1m8Wu6uD3lWbe1II
         Bco1LrR7q1bEfZ8oouXVMoB3SA7rBjilkGlk6qomo6XDchduRYBBMyLlnYw4WA2pE0j0
         4p2NYEqLFuMCH/Cep5j0keXpZV1jkE26uRraegLQcDpJfB0nBHN3qmO2kltxF9i1m6Zb
         zwvVveSjx6cBMNT+pmwWswuz2QaAl9ovQZbzIQZwwgYeYEJAP6vKQrh6yP0uQz5PMpWS
         u6zcs7AAocwKa3JuYrPrnYFyIAD1zs0wy/GxpTCdqduQqlriR+nJxueCvVpioH7d0Acu
         NlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222864; x=1756827664;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S4Qxtfh0XTA1uBqaz5CYZj55f9pkrEroKUb8W6Xu5Gg=;
        b=ILGqYKk3m1U3+DmIUxVf2QQwXhr0Dw35EN4wzVg9I+xzngqzhVqsxJl2pHwNGejl+y
         A9kFqaq9cgfaadozSgIAmZYyOuKQv8OMu4TC7EqKJcrib0JLWPJ+LGDwHf4ow5IoKr7d
         YJPsXeNy5fAlMVYIn5QqZTP9iPlx8gWOkCGCKqsgwcZDKXwYEx+aOVDIZynSVtU6dp+S
         /GtWH0W69l8jROh/gpXOqgkVQGnqBKiWxmGp2TfmUjDm6cqsWamFZ/NtqC8DHTM8dhEh
         eSrqQjxiOp/Yl2NBF6WDm/MjOMBtOKABX/+sBIv/oiYFPIh8ozpgwJhGhdC0rU8FPb5p
         8Lnw==
X-Forwarded-Encrypted: i=1; AJvYcCXCJ5PD+vXqQCjc9S+AsoPCY69wuVfYpAuENOZghJFNhi/HxEFWzbBR7u6OFe9u1hWphnGajBYBCtXd@vger.kernel.org
X-Gm-Message-State: AOJu0Yws/WhavrUNiyobFmYmaO+4YQRk9yA2NdV+RAa2pebeRwBW/RXo
	mHDWQIOmWo12fabq6xua5GfbOcCy93UniCfFISogJbb1ONCE3/NYQe+s/2dff0HWdJC6YTT3wEw
	+efzmIT0bESYVgFol+L8M951seSeVtVk=
X-Gm-Gg: ASbGncsvrFzOD0/2fP3MPqMux2LxOVwqpWhxfxalmjjpak05KdRxwSpYN0EZWaMKPB3
	wOI8ux2/qPa59EULgJPL3vLYmA7oCVzCrO1v5C/potr5+nuROebn4imCNc3TYmCX7y9Gw9e6suX
	mi2WMKEsBfYkb+OefS8aezllIZvzdBzRADHKFZL5uxpcOIF5CI5nXUeEp1kNYjBru2LH5xlh8n6
	pDg+60/tksC+9CAAPi/cjPwGVFlc58+sfIQg6+dSVf47EmQDqecmHAl2FOH0WWOnu10ozXoW3UO
	R0Amqu6kr00MpMKBp3f4
X-Google-Smtp-Source: AGHT+IFaWRcwWSYYL2GJ0tpaJjji9bJet8F3zFdssn2sdZB5LvdFAov6MicGKG93ElUd/OofeiRdVc4rUNf5x6XODJg=
X-Received: by 2002:ad4:4eae:0:b0:707:76a8:ee9b with SMTP id
 6a1803df08f44-70d9738c033mr171436726d6.37.1756222864171; Tue, 26 Aug 2025
 08:41:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 26 Aug 2025 10:40:53 -0500
X-Gm-Features: Ac12FXxsiiZG7BKsv-_eN2DLSK9HWXzc-emowStdhvK1Oef0ABx-oEDMbutKbyk
Message-ID: <CAH2r5mvpzK1NMmbKE-wUDHLhtm_fiPAp=zVm1egw3=cLbUh38w@mail.gmail.com>
Subject: smb2_copychunk_range() reset max_bytes_chunk to 0
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Content-Type: text/plain; charset="UTF-8"

I noticed what looks like a bug in smb2_copychunk_range() - I see it
when ksmbd returns ChunkBytesWritten as 0 we reset the
tcon->max_bytes_chunk to 0 which causes all subsequent copy_chunks to
ksmbd to fail with invalid parameter.  I don't see it Samba (but maybe
because they never returned ChunksBytesWritten as 0).  Any thoughts -
the logic looks wrong?

/* Check that server is not asking us to grow size */
if (le32_to_cpu(retbuf->ChunkBytesWritten) < tcon->max_bytes_chunk)
     tcon->max_bytes_chunk = le32_to_cpu(retbuf->ChunkBytesWritten);
else
     goto cchunk_out; /* server gave us bogus size */


-- 
Thanks,

Steve
