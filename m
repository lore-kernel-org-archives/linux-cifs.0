Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5BC1E5207
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776220539; cv=none; b=o9sTX0IlPu4gCBvgnJCi6O60nS4XdkM/gA73Z/z4cs619LfCsDA5f2VuzG8opM9ehxj13C344QVGXSU/DNyZiReVvHeM2U6RLJswOyGWYF/TG+8PmanCHfjFEQTJ0BT8UEdm7sZE4O0IgAcNmFtGulX4wrNN+CCdkb4kTMPcgr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776220539; c=relaxed/simple;
	bh=N7nd/B1pYZ752n6f4YzwrOygZLD87ZZMTZQ8yqMGFMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRBYG8DUh6E91TjBIdAIhpq20luV052N8n8E/MNWwIOdONp8ULFCaZM1/rZ0l5JxEiFcOki0PTAs5BomXV/0SHtbYyaXENJN9Pw3KxAyS+P9Giwd6DUljDbLHW9CDBd7pyyCB2E+Jl9foT49HsUdDbY55WY+gRhoITrCVRAQnPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QxQFlZoR; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QxQFlZoR"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50b3488fb31so78364061cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776220537; x=1776825337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxRyy2kZK3WlZTfAxVXCb9nX2k5y4s491rvePkeOc2c=;
        b=QxQFlZoRzLOGo7XEGFiTuu3ynPzC/dTjnOrTVpiFA3rXz6E+98yyKs2KbcjcKKs0/h
         9VVZsEQRpI/t1hUX416raV4knVLK4qEPTZ55ME0QWU1iTcJmLS/sG8OtzCn3mdhl1gtw
         XGf+GVRFcUfa47a81CtpgUUcy5xhBI+Adi8Z7G+s2cQnFbOzVji2JUY54Lw5y93mtoL2
         iQVkkzY6z0JDEXyoAb3DlFgoSeKJTwZHU7MmFAhnsL9eSSYRzQ5JCcoRALACdx7c01PY
         60syfQudK0MXpnYoqCJC0XoJ+RyQqkI5mdbARMCINmPx1wjBO7lJHxmHp97byldGUpvD
         +Wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776220537; x=1776825337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mxRyy2kZK3WlZTfAxVXCb9nX2k5y4s491rvePkeOc2c=;
        b=AYUTe03UA10/81aPw8NLEIY/4kC+D2mkvG4bLkbNjDEC4IGYcivGwXVcJz34R4Xgx2
         FCXbK6u/T9qDnhYpvq2zfSEmbk7/nLaDnMT4j97cprtXau9TgQwpB+1GkAc0gJH6QpCR
         LvS6hmA/t2QAhzkgD8xX9XJ3wa7RzihaHzCbRmTtkJ8Lkws8Chh1WogjhM97SPwWqF/U
         htxb1+H5o3BZCAHrhUJ3KDpZKGuh0AxKZUnWVMWzLcyzyvryjEwxu+ZF7aROq88XaNVj
         Wv8bfCH2l6KuGHUTAwNkSZ5eR39Nuu2d9fQeriLGFt5uhKTxJ7ADvulcoLT2I1mnqvFq
         Scag==
X-Gm-Message-State: AOJu0Yy833lS2R0TnL1ytGw7blyGxBSBctthsJeqFcyN4rMCEVmaRtZ/
	2C8DmLCIkalcEOnw8q2uUquAnCl1BY38zTdernCOg7f2OhVJoFuh/itM
X-Gm-Gg: AeBDievsSVSeqN1OKZcKzHhHY5+mYg1LXGaC/6zHN/ZqB8ivCp38zgRY7fvXmaa2IuV
	EM2RdF7FCqSq3dppsU3PYL4mL0+GQkjo15+nCueMFf0orYUGxHEyXrc3LiIo77CfZKC9fI3g8B4
	/TESZj24U9MT4h/f5gulh5Ho2Qme54gi5k7JdXHM+2dqI1ThTKScJSmthDbFdi7q9h4Jp93AMYj
	jZT8DchCzUH/R5OmmFnbZcU9jqeMMcBwPt0qvy4DAeI9GE9iPlrTxkCFIwPWeOmMAHQLrovNJrF
	MUhDd/g4snz+YP/yE6CFkIdiLBCkJR9Zz6njLK4W1K8/smhi7Xh7BGRUU1LrSmrkG4d1CPKR5Oz
	szC9gJ+MRemu3lJkv3KgSp1fq1RORARumoaKqI2wZhzqpFdHil5OjT29JLaBtW2/oYj72kzRaqf
	dHQHFE9gyvd/x6qE5VQdQ/UGZtw9yQjWa52kzCTRC1uZ20TjecEooTFNz7v0Sjd4j54Ll+7ACJW
	QxTlfvcu7fD+HVCNPB9SstWOjacUjDGqs7ayrw8ZQ==
X-Received: by 2002:ac8:7c4e:0:b0:50d:5b0e:1ff2 with SMTP id d75a77b69052e-50dd6bb6139mr240699491cf.22.1776220537078;
        Tue, 14 Apr 2026 19:35:37 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1afdd385sm3024161cf.25.2026.04.14.19.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 19:35:36 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/3] ksmbd: reject negative ngroups in ksmbd_alloc_user()
Date: Tue, 14 Apr 2026 22:35:31 -0400
Message-ID: <20260415023531.2659989-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAKYAXd-pXiJy4S05C_s6sqz6FtnCeCh6Q2c4B7tPuHseA94mkQ@mail.gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <20260414191533.1467353-3-michael.bommarito@gmail.com> <CAKYAXd-pXiJy4S05C_s6sqz6FtnCeCh6Q2c4B7tPuHseA94mkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Apr 15, 2026 at 11:05:45AM +0900, Namjae Jeon wrote:
> With the previous patch ("ksmbd: cap response sizes in
> ipc_validate_msg()"), negative ngroups is now rejected early in IPC
> validation.
> However, ksmbd_alloc_user() still needs an explicit negative check ?

Yup, good point.  I originally wrote the tests and fixes independently
and missed the overlap, so if you accept the cap in patch 1, then we
can skip it.

Two Qs:

1. Should I add a comment in case someone refactors the flow to
emphasize that a check would be needed here if not covered earlier?

2. Do you want me to fold this into 1/3 above?

Thanks,
Mike
