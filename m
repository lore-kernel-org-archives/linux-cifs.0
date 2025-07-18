Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5922912B94
	for <linux-cifs@vger.kernel.org>; Fri, 18 Jul 2025 04:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752811646; cv=none; b=MqXHFNN15MMmjftW+HzvGWX31rH12ssiiwHEM1EFWXwBC6YrcUhdxnzxI1rodotvpBnIY9oyri1lsPbOw6h0eBh8p70J68odt05g+OYKSs5LB1RwoPvxn5Mgc+TYS6XPzMYqGtgU87OF+/mzpOfv5iQlCp4Z5vuWBO+DfiwuxUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752811646; c=relaxed/simple;
	bh=LsAypbFYyQFl8qP6SdysyoeiL1TPs6OBreFzA5J2mrY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dgh2M+o6jJmoLOF4GinXS9IjXp+yBC5IWhNDaXbB0SmO9VjCD6OssvEosP3C00D2G305TNYkS9cbXXPUvuL6zAWsCA8hUC8VEjcEy6x68veRVyKtRuwZHY9EdFAStV6uFIUKVAjoLhbP6ci4FAwcSQDYVaMHJznAJ4lrs6+wzO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3W3mqtk; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3W3mqtk"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7d95b08634fso101677585a.2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Jul 2025 21:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752811644; x=1753416444; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7u7PuI8e8MoaiFGfxTPRTE+KFsuIEbSKe5QQLRuKvL0=;
        b=O3W3mqtkcnKJlNmxYRrPaRwtBFqngGJKEmDo8xC3nA9tUVC4KwX22MtvNQYMCOM2/Q
         KzEpnkwjXy/ZWknYSOGkI5cQT2FnR9AJWL+M6Oti5YxtLJ5TXrulbz4jHL2cTWHP23O+
         Txoqfam/9W8tZ8M8SQZ06bfBB/tqlF8XGeL+2EZw0TB0PjG+ZzPlG7ri+82TF3piXBQI
         eGOj8cGwi4q60vQ0k9XUQXicdte0oRKsfspaGs/Rk/74M77KiljnOGUq6V2bmEjFZnA6
         IMcSHvNa3brY+NU7KJLLOEN2Ppqj0MlazAnKSsR3XpYCaucp0Owfo8cGTb0f32t7k9O5
         UA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752811644; x=1753416444;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7u7PuI8e8MoaiFGfxTPRTE+KFsuIEbSKe5QQLRuKvL0=;
        b=P0lQjk133+XbqTot/FG/BWIk3UxVtEVWYJs95f/L9vhIczc167fPRNWTVZITvJEidK
         IIDyH+3kTu51CXVI5mxnbL/EjV4Sg1SAAuyV5OccsOb9RLRDQ4/ivVs+T35d2cd/l1OI
         RX2YkRAU7CUCi3kOjetDoPbP0WZn3UUXV32r/+eE1rU9+JQsNDam49y1mmJJSrvigO+r
         YpodjaH00mdvZdiAmYZbFt3eNeuq4/ThL2ydyAhJTiKsWlpJ0YkEBNIcH5zM8Uj1bVN5
         2yjIK2Jvjge1IsjMhTz8tK8Qz35FSNME3tCp795exM+OKadybQtEQBqUt5EOSd75JoKY
         GL/A==
X-Forwarded-Encrypted: i=1; AJvYcCXUJPWPtt1tdFZlIlxdJ6RvEZ36XVPNNoFeDkKbw3k6fIz9N1LAKQ19oEPuMTkqmh7OwFymcftnvzpx@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/S8GUBgRNboDE66d/rKUqmrQWqrVn8fnW1RMKtsmnf9Y2mKiz
	aUzQM8s7kOneWGXSP6n2JWN5XlIShASloPZasN0AvlzjxP/KP5zmVJtDs5XNHgoGKx49xFBANi5
	Lrax6q0GVtgCCA59vPVgH8HMMEJ9VqpQ=
X-Gm-Gg: ASbGnctTpavvyzivV1+RGRGh43lDckLS3UyWPXs4nhDcoW5QnHvZ03nqnJZdt41SHX5
	IwgJVqEjXXH4yTaHayvqcJ9KWVMK/+R0Euxu9Wt290H3Tl84GVnE+yQQEHpjXngkC5Rj4hTvDQf
	BzuhRU0RAZNPvzGgoLzRXZO3Nbpy2DPD4OnVBuQ0G1O/HmTvKvGAoWcLkqyDZmgZSt/3fJ3IR3u
	y9vob1k8/4rs0/X9G6SjqCBVTJbG+TXiFOLZbPV
X-Google-Smtp-Source: AGHT+IFwZbOi1gEoQz4VgkUNCzg2hbfaS2P4CJYuTHkfMM5Hla3encwAcg+kuJV3MQn43SwQ5B/L2MGpgiELlw0I9UQ=
X-Received: by 2002:a05:6214:2b8d:b0:705:1175:6165 with SMTP id
 6a1803df08f44-70511756168mr60275066d6.37.1752811644124; Thu, 17 Jul 2025
 21:07:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 17 Jul 2025 23:07:12 -0500
X-Gm-Features: Ac12FXyAEhW1rPj00V9u9r5Dx8jB_Cy_lPKM5LxmTO4wwGqsSmD0H8YhYYFM_bY
Message-ID: <CAH2r5msVdabcDudGyR47StT_VoKazD_A0kdAaGMRh+UD060PhQ@mail.gmail.com>
Subject: Updated SMB3.1.1 POSIX testing results to Samba
To: samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: multipart/mixed; boundary="0000000000006817cb063a2c4343"

--0000000000006817cb063a2c4343
Content-Type: text/plain; charset="UTF-8"

I have done a detailed update of the passing and failing and skipped
(e.g. when test only relevant to local filesystems) tests, and updated
the wiki page so others can add their observations etc.  See below:

    https://wiki.samba.org/index.php/Xfstest-results-Samba-Linux

There are 231 currently passing xfstests from current Linux client to
current Samba which is very good news.

Attached is a script ("run-smb311-linux-tests) which will run all 231
passing tests.

The failing tests are listed clearly in the wiki, and likely many of
them are going to be easy fixes (especially those failing with
incorrect mode bits or unexpected access denied).  Fixes welcome,
since there are about 140 tests to dig into more (many of which may
eventually turn out not to be relevant).

As we fix additional of these, I plan to remove the "experimental"
warning that log during mount with "linux" (or "posix") for smb3.1.1
client mounts, since I am seeing huge benefits with the SMB3.1.1
Linux/POSIX extensions already.

-- 
Thanks,

Steve

--0000000000006817cb063a2c4343
Content-Type: application/octet-stream; name=run-smb311-linux-tests
Content-Disposition: attachment; filename=run-smb311-linux-tests
Content-Transfer-Encoding: base64
Content-ID: <f_md8anti60>
X-Attachment-Id: f_md8anti60

Li9jaGVjayAtY2lmcyBjaWZzLzAwMSBnZW5lcmljLzAwMSBnZW5lcmljLzAwMiBnZW5lcmljLzAw
NSBnZW5lcmljLzAwNiBnZW5lcmljLzAwNyBnZW5lcmljLzAwOCBnZW5lcmljLzAxMCBnZW5lcmlj
LzAxMSBnZW5lcmljLzAxMiBnZW5lcmljLzAxMyBnZW5lcmljLzAxNCBnZW5lcmljLzAxNiBnZW5l
cmljLzAyMCBnZW5lcmljLzAyMSBnZW5lcmljLzAyMiBnZW5lcmljLzAyMyBnZW5lcmljLzAyNCBn
ZW5lcmljLzAyOCBnZW5lcmljLzAyOSBnZW5lcmljLzAzMCBnZW5lcmljLzAzMSBnZW5lcmljLzAz
MiBnZW5lcmljLzAzMyBnZW5lcmljLzAzNiBnZW5lcmljLzAzNyBnZW5lcmljLzA0MyBnZW5lcmlj
LzA0NCBnZW5lcmljLzA0NSBnZW5lcmljLzA0NiBnZW5lcmljLzA0NyBnZW5lcmljLzA0OCBnZW5l
cmljLzA0OSBnZW5lcmljLzA1MSBnZW5lcmljLzA2NCBnZW5lcmljLzA2OCBnZW5lcmljLzA2OSBn
ZW5lcmljLzA3MCBnZW5lcmljLzA3MSBnZW5lcmljLzA3MiBnZW5lcmljLzA3NCBnZW5lcmljLzA3
NSBnZW5lcmljLzA4MCBnZW5lcmljLzA4NCBnZW5lcmljLzA4NiBnZW5lcmljLzA5MSBnZW5lcmlj
LzA5NSBnZW5lcmljLzA5OCBnZW5lcmljLzEwMCBnZW5lcmljLzEwMyBnZW5lcmljLzEwOSBnZW5l
cmljLzExMCBnZW5lcmljLzExMSBnZW5lcmljLzExMiBnZW5lcmljLzExMyBnZW5lcmljLzExNSBn
ZW5lcmljLzExNiBnZW5lcmljLzExNyBnZW5lcmljLzExOCBnZW5lcmljLzExOSBnZW5lcmljLzEy
NCBnZW5lcmljLzEyNSBnZW5lcmljLzEyNyBnZW5lcmljLzEyOSBnZW5lcmljLzEzMCBnZW5lcmlj
LzEzMiBnZW5lcmljLzEzMyBnZW5lcmljLzEzNCBnZW5lcmljLzEzNSBnZW5lcmljLzEzOCBnZW5l
cmljLzEzOSBnZW5lcmljLzE0MCBnZW5lcmljLzE0MSBnZW5lcmljLzE0MiBnZW5lcmljLzE0MyBn
ZW5lcmljLzE0NCBnZW5lcmljLzE0NSBnZW5lcmljLzE0NiBnZW5lcmljLzE0NyBnZW5lcmljLzE0
OCBnZW5lcmljLzE0OSBnZW5lcmljLzE1MCBnZW5lcmljLzE1MSBnZW5lcmljLzE1MiBnZW5lcmlj
LzE1MyBnZW5lcmljLzE1NCBnZW5lcmljLzE1NSBnZW5lcmljLzE2OSBnZW5lcmljLzE3OCBnZW5l
cmljLzE3OSBnZW5lcmljLzE4MCBnZW5lcmljLzE4MSBnZW5lcmljLzE4NCBnZW5lcmljLzE5OCBn
ZW5lcmljLzIwNyBnZW5lcmljLzIwOCBnZW5lcmljLzIwOSBnZW5lcmljLzIxMCBnZW5lcmljLzIx
MiBnZW5lcmljLzIxNCBnZW5lcmljLzIxNSBnZW5lcmljLzIyMSBnZW5lcmljLzIyNSBnZW5lcmlj
LzIyOCBnZW5lcmljLzIzNiBnZW5lcmljLzIzOSBnZW5lcmljLzI0MSBnZW5lcmljLzI0NSBnZW5l
cmljLzI0NiBnZW5lcmljLzI0NyBnZW5lcmljLzI0OCBnZW5lcmljLzI0OSBnZW5lcmljLzI1NSBn
ZW5lcmljLzI1NyBnZW5lcmljLzI1OCBnZW5lcmljLzI2MyBnZW5lcmljLzI5NCBnZW5lcmljLzMw
NiBnZW5lcmljLzMwOCBnZW5lcmljLzMwOSBnZW5lcmljLzMxMCBnZW5lcmljLzMxMyBnZW5lcmlj
LzMxNSBnZW5lcmljLzMxNiBnZW5lcmljLzMyMyBnZW5lcmljLzMzNyBnZW5lcmljLzMzOSBnZW5l
cmljLzM0MCBnZW5lcmljLzM0NCBnZW5lcmljLzM0NSBnZW5lcmljLzM0NiBnZW5lcmljLzM1NCBn
ZW5lcmljLzM2MCBnZW5lcmljLzM2MiBnZW5lcmljLzM2NCBnZW5lcmljLzM2NiBnZW5lcmljLzM3
NyBnZW5lcmljLzM5MCBnZW5lcmljLzM5MSBnZW5lcmljLzM5MiBnZW5lcmljLzM5MyBnZW5lcmlj
LzM5NCBnZW5lcmljLzQwNiBnZW5lcmljLzQwNyBnZW5lcmljLzQxMiBnZW5lcmljLzQxNyBnZW5l
cmljLzQyMCBnZW5lcmljLzQyMiBnZW5lcmljLzQyMyBnZW5lcmljLzQyOCBnZW5lcmljLzQzMCBn
ZW5lcmljLzQzMSBnZW5lcmljLzQzMiBnZW5lcmljLzQzMyBnZW5lcmljLzQzNCBnZW5lcmljLzQz
NiBnZW5lcmljLzQzNyBnZW5lcmljLzQzOCBnZW5lcmljLzQzOSBnZW5lcmljLzQ0MyBnZW5lcmlj
LzQ0NSBnZW5lcmljLzQ0NiBnZW5lcmljLzQ0OCBnZW5lcmljLzQ1MSBnZW5lcmljLzQ1MiBnZW5l
cmljLzQ2MCBnZW5lcmljLzQ2MSBnZW5lcmljLzQ2MyBnZW5lcmljLzQ2NCBnZW5lcmljLzQ2NSBn
ZW5lcmljLzQ2OSBnZW5lcmljLzQ3MSBnZW5lcmljLzQ3NCBnZW5lcmljLzQ3NiBnZW5lcmljLzQ5
MSBnZW5lcmljLzQ5OSBnZW5lcmljLzUwNCBnZW5lcmljLzUyMyBnZW5lcmljLzUyNCBnZW5lcmlj
LzUyNSBnZW5lcmljLzUyOCBnZW5lcmljLzUzMiBnZW5lcmljLzUzMyBnZW5lcmljLzU1MSBnZW5l
cmljLzU2NCBnZW5lcmljLzU2NSBnZW5lcmljLzU2NyBnZW5lcmljLzU2OCBnZW5lcmljLzU3MSBn
ZW5lcmljLzU4NiBnZW5lcmljLzU5MCBnZW5lcmljLzU5MSBnZW5lcmljLzU5OSBnZW5lcmljLzYw
NCBnZW5lcmljLzYwOSBnZW5lcmljLzYxMCBnZW5lcmljLzYxMiBnZW5lcmljLzYxNSBnZW5lcmlj
LzYxNiBnZW5lcmljLzYxNyBnZW5lcmljLzYxOCBnZW5lcmljLzYyMyBnZW5lcmljLzYzMiBnZW5l
cmljLzYzOCBnZW5lcmljLzYzOSBnZW5lcmljLzY0MiBnZW5lcmljLzY0NiBnZW5lcmljLzY0NyBn
ZW5lcmljLzY1MCBnZW5lcmljLzY3NiBnZW5lcmljLzY3OCBnZW5lcmljLzY4MCBnZW5lcmljLzY5
NCBnZW5lcmljLzcwMSBnZW5lcmljLzcwNSBnZW5lcmljLzcwNiBnZW5lcmljLzcwOCBnZW5lcmlj
LzcyOCBnZW5lcmljLzcyOSBnZW5lcmljLzczNiBnZW5lcmljLzczNyBnZW5lcmljLzc0MiBnZW5l
cmljLzc0OCBnZW5lcmljLzc0OSBnZW5lcmljLzc1MSBnZW5lcmljLzc1NSBnZW5lcmljLzc1OCBn
ZW5lcmljLzc1OSBnZW5lcmljLzc2MCBnZW5lcmljLzc2MSBnZW5lcmljLzc2MyAK
--0000000000006817cb063a2c4343--
