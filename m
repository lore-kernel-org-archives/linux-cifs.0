Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251681E863
	for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713866037; cv=none; b=O8UWYUPiTbkI0jGsOo9nLO96SHqANeRC9In7Nr6KNz7cK1kaqvrt2t4hO2Xr9nQnmNiMJc7+zHPcfxBwwPHaoLtNWfvKqLqRb+Ti87SskGbMv+C59wiuVxGAxCaz/+uL1vOuqVdaEbq/n4ZIigIbvNGbKEMac5p2H9uid1sYAWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713866037; c=relaxed/simple;
	bh=Ir+xFAi61xRTten9cniwix6gtgJgHjCwLGXJzLjcCbg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=o17m8w/QvRn7ddYEMZbQDuf3AsKXxnFpQt41GWb8zPkxZx4ZgSHDX1ZcqAAv9PmnY3VuumfiHv1YKiuEAotoV2yU0cV+FXThzcwlcnJXXO4KzKKicBoy4aMPBSTMlY0Dl59KjlN3g3vjPRt0mFmLsJHJM9cMMQFKAcMc3TInpIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NYZmW1wx; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NYZmW1wx"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-345b857d7adso4304393f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 02:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713866033; x=1714470833; darn=vger.kernel.org;
        h=content-transfer-encoding:organization:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hDxBsJ8k1FvINlAXy8oi90cyE1GnjJcj0eADIvqdUuw=;
        b=NYZmW1wxKZmXmgfFOrO//G37EX2GUpfWLl9KHUDie9+1uVyNyNSOlqOhS8Bv2khDPO
         U852t1IIi68waqgByc5CbQrQjCbQ6iIu5HYRo7cHsiWP9s5hbXIr3wA7hLy+FvM/KNou
         YpawVgdCfa536KnPycGRXTHn0VVbz3YID2stZ/4b4fqBDC5WYArsGbMQ8SUuPJjjDlvU
         WTHY1/Gmc/pJ1Zc2AKglxw/uzMSPEmD2YID1FtdV/G79GDi1xujdRO1/JLQdRdYCi5mv
         Ok0h67l9PTo3uSAVRKDuPZZPHYl/xbr7MvE/oC+q2YUkbV9B+02OtTesQSScSZI31dTy
         GlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713866033; x=1714470833;
        h=content-transfer-encoding:organization:subject:from:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDxBsJ8k1FvINlAXy8oi90cyE1GnjJcj0eADIvqdUuw=;
        b=xFTzIOhnEWNsTgxPP6UZZ35zvPQTaRPJHzWUQzeCxfuV2cDazELsxny+1DJG2SpNfV
         slTi76sZR84lpfuC3cgeiqCwx7GCklQ2FHVawZ8Mp+WkgY8qdkbCQMUl53Xvkl+s9Lcs
         7F+fMfdfR+XJEYHLFYEh9MbHM0Jwd3yBVWr0UvJTzhCocE5sAwoSvcjP4KDV9gGh3aXj
         HxOHQda85npmCengqjBOnxJKrdyeYCWlRpw0ToKtrx9di/x2PRcHORT/8AxBFRl3ey0V
         mpwtKA2eY230niL9OC7PVf8lEUjc3xwpjij7MufZGO8EPbbUwltEg86zdGi33s18f3JB
         n4wg==
X-Gm-Message-State: AOJu0YxFjdjPqR6uEuGSls1UTHvANK5A+pxmz0fL4GkycPq0h1p5A1Pm
	GnGp9BKEoAQCZdEMfVUzdGlRv69h1lf270lF6R2/C/d6jSGIfMdwnqfeT6tJVROHtbwJOWZxskT
	L
X-Google-Smtp-Source: AGHT+IGLypZA+I6tpK+/6Q+OTmWPX188u6BY2+vakYLFsJm/EWFDyJiK/a+l0StAdEajUASMG3Ryig==
X-Received: by 2002:a05:6000:186b:b0:343:74da:bc7a with SMTP id d11-20020a056000186b00b0034374dabc7amr12232729wri.47.1713866033255;
        Tue, 23 Apr 2024 02:53:53 -0700 (PDT)
Received: from [172.16.1.175] ([80.95.105.245])
        by smtp.gmail.com with ESMTPSA id y5-20020adfe6c5000000b003436cb45f7esm14081310wrm.90.2024.04.23.02.53.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Apr 2024 02:53:52 -0700 (PDT)
Message-ID: <fdb2c85a-3692-4e99-a25b-4b17759071ba@suse.com>
Date: Tue, 23 Apr 2024 03:53:51 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-cifs@vger.kernel.org
From: David Mulder <dmulder@suse.com>
Subject: 128 bit uid/gid (UUID) possible?
Organization: SUSE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm messaging linux-cifs about this, since it's a relevant topic for the 
Samba team (and I'm unsure of the appropriate ml for such a discussion).

What is the possibility of increasing the uid/gid size in the kernel 
from 32bits to 128bits? If possible, how large might such a project be? 
I imagine it could be quite disruptive, but I'm not sure of all the 
implications. My question relates to providing authentication 
capabilities for integrating with oauth2 applications, such as Azure, 
where the user and group object ids are UUIDs. In SSSD and Samba, we're 
currently in discussions about what the id mappings would look like, but 
I wonder if we could take a different approach and make the kernel 
compatible with larger ids instead?

-- 
David Mulder
Labs Software Engineer, Samba
SUSE
1221 S Valley Grove Way, Suite 500
Pleasant Grove, UT 84062
(P)+1 385.208.2989
dmulder@suse.com
http://www.suse.com

