Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F8262FD3
	for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154901; cv=none; b=fsGsjXtDc6I2oYJx1rgCWwDcMfCrB/upczphS704Pt9xWMk4dDYFYBogaGwxJd5rUq3DelJ9On+qkh1Z3U9Gjn0fku9X8i+EGIbamdhAeo1dnK202q48v3IAw8/lGV7c2WD5Z8mmmX21GXoup8Eb3Bp7xLU78b5fgMjwVeikItM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154901; c=relaxed/simple;
	bh=Y2cPTKyp8+pa4kvRMd2DbHQIqkwHAegaMbr/kZOwiA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eENW4UYTtAWu2ru+7eBymGdXej3dPXQCn4pu1ZAAomkOofq7DZJFPDhoV/7ENrREpV/6avb/KHr2lt9IFhS6lS3aZQPYgDDWJMaEMS+GkfpOIBdvLGqO0I6NCb3ChaRsNbTGeUzSSQrUKV/x0EZWytPeg4f8gwCe9ox0RT8uYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=XEgfwOn6; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="XEgfwOn6"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae0c4945c76so152733766b.3
        for <linux-cifs@vger.kernel.org>; Thu, 10 Jul 2025 06:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1752154897; x=1752759697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2cPTKyp8+pa4kvRMd2DbHQIqkwHAegaMbr/kZOwiA8=;
        b=XEgfwOn6lEE9/qgA61ga1NXFOke9ca1L74o1p+WZjkWJ/CM8+cXLpM0vWp4RAJlLmt
         E8/aZmPgy+LXVRv48r6krjog3A0x17OhAewlZxL7OkaVnj856GbgLsg2QB1/aszz39oz
         BuY+cNeHTRWSvj0R0JYI/b7eQdDRE+7TgV0Li1xTF+K9owuvbD/axBa6hxrc6Q9cFS3n
         4q6nkCk8BMNizCuUGd07o5psDhI48EXo+KMKRTMof/QYIrsbZGFdKDjw4hsPqpt/0OH5
         NCfpXVYRoeOdWeXWxUuAsZ3kndaSvJICAtqmuRNWcPry50hpsC+ldjdkaBZ9kBt8vJ5X
         OxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752154897; x=1752759697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y2cPTKyp8+pa4kvRMd2DbHQIqkwHAegaMbr/kZOwiA8=;
        b=AlW+zfmd0k6T6BQC3RfT5IKwLFWE8SzRz+23C/8I16JpOY0hF16fTEv9FU2j1L+i12
         PrN/HPtwLcus0OYQlvj2i/0he1ai2qXj+vmhhfOYj+n4ZD3LQ0+ItFilr35qxJBwpVid
         jfA9pHxbalJ104Fj63xdBgvW/lAEVuE2UlA9OI9lYRsMy+6rjl5jDZ8kBy2Cx1heemPw
         iCxM9HduI9O+o55590iXP7ZusUmzKiZ/eYZOQmqYm/AhKGVMsqn+sqYdXfLV5Q+hMTn5
         lb07ASRfhTXil/C5nicZntVUo/2c5W1RWHtzXkUuod53KEz5QZRm6wX7EuWAuDS29n+3
         7jCw==
X-Forwarded-Encrypted: i=1; AJvYcCUmkoJXp7CEo9+n1d3aTYgXRd58ecmdEfvTc64dzrFqJQ3AZ8Wr0IRQZlwGNPEgDvwjQjputYr48xiy@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr0aTjMmN9hRSjZIfSLOi2GykocG3fmKx7UG9l2yj/5XoLhYEx
	JCfICU8IV2NM+0afTynRm1OqqwPSQpVY8uJi8X1bbhOcDeBkgDe2hzTxj/gdblA8HDUKGxjlvAz
	Dh+7ylhG7vHp9F+mDCOx6N/Lh/fptCk6vxb999d2PeA==
X-Gm-Gg: ASbGncsq2/m3+khhQPtmaTD+p3PMUmM2aSEEPVG6Y/W37RMeW9usILExcgD2YQbE+zJ
	Q1kDinam7BADOx4i325uAj8tKz1a/ON+ZIXwaViCtG7uyfttcRMULV+n46ZJhce2LFKPqBb7epi
	74g0xDy/J2Vegb1p9FzS4YZ5I9pH3hqxbv5HbEADtlEyPFAYAGmeBctQG3+1bKZGgg4Sbm19Q=
X-Google-Smtp-Source: AGHT+IEUfIhpap/ErtxncROC/XukLmMNwnnCP5z2dolLnhei5TAHwMgshdrm44CHSjNOH/5s8BRS/dOJLaexhl9LvyA=
X-Received: by 2002:a17:907:d93:b0:ae3:6390:6ad3 with SMTP id
 a640c23a62f3a-ae6e6ea0035mr262408366b.22.1752154896676; Thu, 10 Jul 2025
 06:41:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701163852.2171681-1-dhowells@redhat.com> <CAKPOu+8z_ijTLHdiCYGU_Uk7yYD=shxyGLwfe-L7AV3DhebS3w@mail.gmail.com>
 <2724318.1752066097@warthog.procyon.org.uk> <CAKPOu+_ZXJqftqFj6fZ=hErPMOuEEtjhnQ3pxMr9OAtu+sw=KQ@mail.gmail.com>
 <2738562.1752092552@warthog.procyon.org.uk> <CAKPOu+-qYtC0iFWv856JZinO-0E=SEoQ6pOLvc0bZfsbSakR8w@mail.gmail.com>
 <2807750.1752144428@warthog.procyon.org.uk>
In-Reply-To: <2807750.1752144428@warthog.procyon.org.uk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 10 Jul 2025 15:41:25 +0200
X-Gm-Features: Ac12FXzl_JlkX217YnsQK9NDpeOWbIXCejwCEnw4V1qbmZHn5mJ_E34Ih5jkMNQ
Message-ID: <CAKPOu+9TN4hza48+uT_9W5wEYhZGLc2F57xxKDiyhy=pay5XAw@mail.gmail.com>
Subject: Re: [PATCH 00/13] netfs, cifs: Fixes to retry-related code
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Alex Markuze <amarkuze@redhat.com>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, netfs@lists.linux.dev, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 12:47=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
> I managed to reproduce it on my test machine with ceph + fscache.
>
> Does this fix the problem for you?

Yes! I can no longer reproduce my problem.
Thanks, David.
