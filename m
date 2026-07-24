Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5342D5937
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 12:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896318; cv=none; b=YSsT/OOwSiXSqi+R6le03ZU8dK6Xu4q69AUDd2pYIl5Ngf23KqRd6jUiUFDRQXCZnv8Of2PnV3+ZIhoRRpldp5Q5v2I6Qg7yed/JVIJky+9TA7QAG6slnCWQqXfrGU2TLG/l5cyLDfOIGtUwTIONcouPOFWN5zDcq+reWHfvhcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896318; c=relaxed/simple;
	bh=6TlwezWM4AFq2yI2DeU12+GAlAO7JwgsJl+amDoGhe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il+ijfOe3Cw6inZ2ztogSsLiJntrbH85Y66zoOJpVESdp+dgxUAh5AMFpKSyyX70Vd0c+x2jOY8vToiM1YG33mDM3J/mzBhYna/YHQKmAQGM20E/pq8YH/l/cJ2PDZ/MuyqqkBp4ayC0kkqhSY3ZZW+ok+7ZyTL9g/rOvtNo2pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKlmwR3m; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKlmwR3m"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so262156a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 05:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784896316; x=1785501116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6TlwezWM4AFq2yI2DeU12+GAlAO7JwgsJl+amDoGhe4=;
        b=AKlmwR3mckCaq3aTRQOZo23RmpCs/1cdZZPbhz2W4cH286SNPybWjZSLSNTBr3EyKP
         c3zLKdh7PphBKtuVdbz+0CrE27k4W5WVi8PC3wwo+ZNBeL+X3FSzpnyHhtw1vEYy+zJj
         1DecbeQkvjqqlegagWBMDYEQwx8PE/2bXWxE712YXiy5yuDP9eQV4bwdLTLd7GckfAzT
         0GNuTVyQ5z05KKzXnmN69Zm2RiuscpsNiq9kbw8IIZnF+/aPfvmQo24Ra4uerRDFA8e+
         /jUY7KpQjPck2mT6qD1PuG5+4SN29QDU5Zkhpj0ODjlwWmHjO6WEExE27qqnuzzk8Pub
         utsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784896316; x=1785501116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6TlwezWM4AFq2yI2DeU12+GAlAO7JwgsJl+amDoGhe4=;
        b=Z/R6e28VeX7AVjkSqvmvtM8W2RrADo0VRrPbzmu8q9DIUyH5DUMNpzmIu9ZjiepqRl
         XnQao35TSim4G8gNXdgX9RZlX7ZNnbLBbzZnslCfng8fDDRlHx17SY91a4VmM+4RorqE
         1wu5ho0iQz00rXq2vPyUhAW6iuj+tNG3bbPglrVdqKXSDoQAUE9zJBWCdTDh/EOWwhgK
         pm8mzAJUxjvX3wWY7uRpOAIFpKisT94+85zuP1nV4uM3VVfcnvuCzM3zvdFqhyB8PBzg
         5UI0sNbqtelRTF+8/ykWq5dben2DrDmaKaXNoJJdYeiTO7wdapF5DqHYoYDkZhRybbsZ
         QaqQ==
X-Gm-Message-State: AOJu0YzF/InuTvis0p0GY7G5vnJiuUF4ir1EAmVxTeI56lkv+AmhXYLK
	IWPxZUsiDnfxURcQLpeY1s6otND2SqkJDCgfXCBAFoQXhMoB+VgmcxXR
X-Gm-Gg: AR+sD136PNgfn/gv/Jp8vtg4YtfUzjtAHcbG8M059QgAUWG7N3dDwrnvYssBZ/Iy3Lj
	4d5sWa/d4eC4hwBdOURWzHDmKhxEnaeQzXWb5mRYs3sMaY4iOQwYnyuzHlztZk0/OQzl/BPXhKP
	1SlVgakt+65Sxy51cSEId72p+we8BEd/64Wv54XzuD0q6HXmt0mvO+AmuyMl2fI/Vj3vM4ty+8p
	QQlCYbJQZVOnxIsWxzXJZMJZugJY5ZDr4p4GFqaULd3TQ8Y1bLo7C177tjxmbKVUlvE3D+/Y09h
	5RnGlHA9e0nKVLYyGn60bkg4IzS88t+5/cDdaLPMjt/V4BVA6mrwT5AB5cKN7Cb0pfQUerjEyFP
	fgsyOJ5TA45NkA5J9FZHmvbEZDE2hB4R+J3g6L0900Krb+iWkTw8vDMCbxhB1oNVZHvAmGArBOQ
	n4
X-Received: by 2002:a05:6a20:9398:b0:3c3:92ba:c61f with SMTP id adf61e73a8af0-3c44afab1cbmr8230787637.8.1784896316162;
        Fri, 24 Jul 2026 05:31:56 -0700 (PDT)
Received: from ubuntu.. ([2405:201:8026:213e:9261:769c:50a5:6d0e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm31405788eec.31.2026.07.24.05.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 05:31:55 -0700 (PDT)
From: mdshahid03@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: remove redundant NULL check before kfree()
Date: Fri, 24 Jul 2026 18:01:34 +0530
Message-ID: <20260724123134.122865-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703122104.69788-1-mdshahid03@gmail.com>
References: <20260703122104.69788-1-mdshahid03@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Gentle ping on this patch.

Could you please take a look when time permits?

Thanks!

Mohammad Shahid

