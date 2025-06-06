Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E201D27E7D8
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749198513; cv=none; b=Lu24k1J79A4k/5T8E9wnvRjo5KLNBI3qM1eqkfHS/7P6tRjZC/3Eq/0hp3HWMfq9nvqS3rCQVcZZFi4dwuKGyt2ddXOQe35d1pA1/BCdBE0G+1VFqkk8Sqfquo1FohQyXPOSx0gYNlaz5jZo3DMavLi4+3ZRcyLNUkDATBhH55M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749198513; c=relaxed/simple;
	bh=hsX7jd8Uqp6+hYPz0rpI7skahuhQNzegzC8jM+Uo5/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N2m7pRjQo31NxQpSvz7Apor3/Owvzg5leCGFcbl/cS1soAQzzKnDaOqwVUUMNaNatcXYhD5u/S7a8FShOmmVbaelBTwjTggaPZyzJIFQynT5N1FedPTwB6mgVuHgqkHObS2CAahHVO4eNqGwfF84Dsh/oxpyM3q5f82q1FJmqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WM3ofJok; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WM3ofJok"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e812c817de0so1760935276.0
        for <linux-cifs@vger.kernel.org>; Fri, 06 Jun 2025 01:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749198511; x=1749803311; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hsX7jd8Uqp6+hYPz0rpI7skahuhQNzegzC8jM+Uo5/M=;
        b=WM3ofJok+lSALmrxCIWjlQZmsP/cg5GxLshlw/zAxrn4uxZduXcqem7QsIKSqnTfO1
         CqGC9vOfiiH6xVi6YF+qHsQo7VQt8LviIAIqTBg51lhwhiecJ8JjfuUjUnIRn0K1j1LW
         4Mhnw1AQcRyzWNjO1b0g5KrXlGFpXH2IB5juVYVQi+mEW3uzzWSImhYmNTHWHr/dOHgu
         Xq2JVWuseZBW0t9cdE5zP1n9dyw53EZRYGY+G936Ki4p03QPvQ/4qB+3QojqklcmgwtB
         ZDHXyonGDaYPk2Far3q4CuUJiqhyL2teDMg41LkN0Ip7nG5mFwga4+cWYknYIY4tc5WJ
         cgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749198511; x=1749803311;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hsX7jd8Uqp6+hYPz0rpI7skahuhQNzegzC8jM+Uo5/M=;
        b=vnp/iZALeSuh915w2v+fuJzb5Ijo3W/X75FHMhx84m3mdl0lqegTiCb8dBR1yCYVYO
         YfH970IXHIbQXCcxFmiTqZ6zHwhNhn4PFBUdtutaZLIUATZJQNf+d6k1hbgyCobfDK9E
         +T6J6MYdggNjtPvbyQniUVZ2d+04WxohGvRu882zwK76KnNkPbT/KyIEOnSwXtG7f2+a
         RKYZPKcrmfLhnugLZ5F/Sbsh9NS7KmDS+YSdmPFTFR1y8gZ2tC0snYodwY1U3uTXJw10
         lQOYllzODPORYR7FDj3VNnF18pstwJonWYzDCRrN2Vm1X4/xqXpdAAMi7X9QBmqv4vb+
         9XTw==
X-Gm-Message-State: AOJu0YwrA4jA7J8whYutTFtkEGQiIWCo/n1r3wy1mpGSDQLgbbPxYRO6
	Ww3ka1DmSjtbUdwi4McZZID9i/2//9lyxmsm4OULzc1WaEXh+Hlz1YSDSE9sM9maYhciPxnJLWD
	vm3yNThZnvzXANtEEIhdXiI1VIqwidI/pzQA4
X-Gm-Gg: ASbGncsT1FSuYWQOORWDsMA5xc2A6yPNVEdayJe8UprPqrxv6V2y13ipEdB7kdWJ1zR
	kN6CaUGCMbFqTj70qfpQfYr3YM2lfsupFrEH+N2ZsypRH63W0DrxVOfnywOX8AMwg5EdZIpGTrq
	RS8VbXjeGxZGo4xZL4Q0iyO1CwMvRHiKDzUFWVA6Km
X-Google-Smtp-Source: AGHT+IG0wRs9+VF8lf3Q9MqhmHhTS4ShdyFKkte/ueAOo2clwSfj1Ji+vnZhJLMoBM9uhlFOcz9rtCDOibi2Q0I96E4=
X-Received: by 2002:a05:6902:4911:b0:e81:992c:944d with SMTP id
 3f1490d57ef6-e81a214a687mr3910995276.29.1749198510718; Fri, 06 Jun 2025
 01:28:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKeu6dXUhLP2cjagz_+YB2Esf-rnj3RQHWaX96R2bEBOk0C6dg@mail.gmail.com>
 <35a57e9c-e5d5-4e78-93d7-83fc147080fb@huawei.com>
In-Reply-To: <35a57e9c-e5d5-4e78-93d7-83fc147080fb@huawei.com>
From: Maxim Suhanov <dfirblog@gmail.com>
Date: Fri, 6 Jun 2025 11:28:19 +0300
X-Gm-Features: AX0GCFtl6Xx_tZ8n6ZIIiL-pnvEFAViG5A57thCWMTfRprHm-N-KJ-8c5zhFK_c
Message-ID: <CAKeu6dWbejr5EbL=AxWrYDFp7cPjkovM7g+Q-jfrmGR0+wfnxA@mail.gmail.com>
Subject: Re: [BUG REPORT] smb: client: find_cifs_entry() suppresses some errors
To: Wang Zhaolong <wangzhaolong1@huawei.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello.

> If the original error (e.g., -512/ERESTARTSYS) were propagated directly,
> it might result in unexpected behavior in userspace applications, as
> these programs typically do not handle raw SMB-level errors.

Usually, file system drivers (like Ext4) propagate I/O errors. For
example, a read error in a directory block on the Ext4 file system
sets 'errno' to 5 and the following kernel messages are produced:

[ 4995.871562] EXT4-fs warning (device dm-0):
htree_dirblock_to_tree:1083: inode #131073: lblock 18: comm readdir:
error -5 reading directory block
[ 4995.871919] EXT4-fs warning (device dm-0):
htree_dirblock_to_tree:1083: inode #131073: lblock 18: comm readdir:
error -5 reading directory block
