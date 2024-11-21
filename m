Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A681CACEB
	for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2024 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732184584; cv=none; b=e7NDRixMr1btp0G8EAUWfzyk/NDkDfnpzkM4cArW78byIhZlyq8U2GyCxyqlAPsxkayfN1JjXyrOlnLLzwwAP1Cta/pMZXdvQyWFRH5X9dBiMl7nkNHov7HiqSIuP6CAD6Rl0IRPFwziVyuh0ZhabpcmSdvQF25vqFqqQGwufxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732184584; c=relaxed/simple;
	bh=E2jN+fIpOwCQVv8dVjOgj91jNzi+cJBO8+WvxPhXqQk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=kFm5J5YDlVk1w4JQI8zqBLl6BC1XjyMd6NddzQF/IaJC5TYMt1//ehADvRCJN1QJDQJJB0sqAKOU7cAJ1OJoIm/KrSS91fQ13f+B/yGM9WAEpllyiyK57G7CJq6BOpTaKS3L3QxVtU65Hr5Bgffi202v8rh3NWwM9eravrQHRVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+rMNTtw; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+rMNTtw"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5ceca0ec4e7so866711a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2024 02:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732184580; x=1732789380; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zFX1F27lbKu/9fUfbEaMBZrBcRHt0L0VABWW0WVaO0Y=;
        b=B+rMNTtwSAul1xiqC3yc/T3dYdcEKMPcuho2O5yIVNgfJu3LV+mwv+CRm7wKzufS69
         QK3+WAFKy/iKBkuNV9Th8xOimTUGcR35hrj6D99ZKNExEXkGaph/bXsiJxqlMokz5mA4
         lfeoNEqlvZ6JP4SRMABNtfRKOUStvOb2YKTnQL6RyfZSnSnVpcO3hk/zotxVkDiU+B42
         23wN7zAdZT8INVCfjqCjIuW8FVjkmMBgsRRx6SSsOxawlJJGVEtdHq2d53CHkgyLq2tf
         hAivhA+Al8jAXBBsZG8jJCQBGcZlTSwJo/KXhPB+x82piLG70ftqcrUTBPiaJ6ZXqlof
         s5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732184580; x=1732789380;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zFX1F27lbKu/9fUfbEaMBZrBcRHt0L0VABWW0WVaO0Y=;
        b=XIqdhkeINzxbkQS8JfIK7uAAZHcSPo0M9LnwUL896ObqL6KuPAeCGQtjYM7LxFvA6Z
         n0Wk/8XyMaDwhtzPxAMarn3CaKvFAlCdNn4COv73YwVMwIeosbQBZ1EdLo5z14j57ilG
         bqKuwd1irY5xW9gEYqZOZMYJUkpUHm5zx7Xhq4gA3KKALdbg67j0MRXEQNhBfIi6nwC0
         mEMVWdc/QdzviAJaA8suoPx7n5RShaouUxg9x3mSVUt4axcWSwQcFs/kB4Xaag4p1G+6
         Zdfi1SBiK+S52gYgZTzh6pvfwXpO0L4B0Ygy7UJ02pimrpYdtnAUsiK8WPjWFD8O+vpE
         wfTA==
X-Gm-Message-State: AOJu0YxxEkKCYLve9tljMq+go7HkYtTO/X4Y+HEN/B+j1UJVqZb3ALPx
	F1vg+Q2Ds6SnZPesmTlqZ5B6Z7i2a0fIO3rwEWC4FYX8Dp3s974pPvSnLmzZ4o/7vzR5ZuCKT/e
	A8qlbfWpL5Wbhi6XVafIHgOslj8em2UTk
X-Gm-Gg: ASbGncssqWwndhypum6fXq5pEAq3voVMi92KMrRyDEQu7ratD+rX86p1kGrFqhi5hu/
	+8UpaxO8SD1JV6hlrpY6O9R+0ZCdsbT4fQE0WDBRWVdOq7ilCPbnhtHsMxPwk
X-Google-Smtp-Source: AGHT+IFFiUBhbnky7bZNp9UGaIrWe5ZXe02d1ADl0MlQ0Y15HYundFbNaysSwIZd1Aob6OwNqBwZ1hHlmcfW9NbIVvw=
X-Received: by 2002:a17:907:31c2:b0:a99:f4fd:31c8 with SMTP id
 a640c23a62f3a-aa4dd551be8mr532514466b.22.1732184580337; Thu, 21 Nov 2024
 02:23:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Eduard Bachmakov <e.bachmakov@gmail.com>
Date: Thu, 21 Nov 2024 11:22:34 +0100
Message-ID: <CADCRUiMn_2Vk3HZzU0WKu3xPgo1P-1aqDy+NjEzOz03W-HFChw@mail.gmail.com>
Subject: man: Incorrect description of mapchars and mapposix
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I believe the manpage is incorrect here:

mount.cifs(8) (as of cifs-utils 7.1):
> mapchars
> Translate [...] reserved characters  to the remap range (above 0xF000),
> which also allows the CIFS client to recognize files created with such
> characters by Windows's Services for Mac. [...]
> [...]
> mapposix
> Translate reserved characters similarly to mapchars but use the mapping
> from Microsoft "Services For Unix".

Inspecting the logic in fs/smb/client/fs_context.c (as of 6.12),

    case Opt_mapposix:
        if (result.negated)
            ctx->remap = false;
        else {
            ctx->remap = true;
            ctx->sfu_remap = false; /* disable SFU mapping */
        }
        break;
    case Opt_mapchars:
        if (result.negated)
            ctx->sfu_remap = false;
        else {
            ctx->sfu_remap = true;
            ctx->remap = false; /* disable SFM (mapposix) mapping */
        }
        break;

it seems that the opposite is true. Given SFM also deals with trailing
periods and spaces, I think the minimally invasive fix is to swap words "Mac"
and "Unix". And maybe mention the period/space thing in mapposix.

(Also, please s/asterik/asterisk/ in mapchars.)

Hope this makes sense.
