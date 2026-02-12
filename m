Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43EA10785
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770917151; cv=pass; b=ol7LiC7VdbNOf2WJKHnSd9oqgvY1wGAbLoniOa5FQOGRseK+lzyrhRp9bIqQqRgUbCB93DsjqbAs3wnuj7tSuRnzXYw2ze7NiTv1Ip8/ZqqQTIzTyH9qq97Y9aB3e4TVFIJGFKa3CsvMD0Kckt3slT3ooRindvUkxbjkKq3OYqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770917151; c=relaxed/simple;
	bh=03hxOrdYCoqmJuehfr9XJmXECWcWCSFc7ywI5Fo6ocY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TjfWKMYMRJTKzl06imkfXkRf1Ne20Z65FXp9rIxQTD6y6RHxa0+p84cHCbLRiwUdLyCCSXC2TAfW4kDIyb6y5HermBvMTkXex8iF9gnJDqws6er5otDg2Nu5JezdatMG+nt3lZLPoWzNcgwN0/sDVQNCCkNDtW8QWdxH+thIZzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ElgSKw9U; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ElgSKw9U"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-89577f866d6so940356d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 09:25:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917149; cv=none;
        d=google.com; s=arc-20240605;
        b=lJwRY96GvYl3/WowGSCzJFXZNVrv4h9HXO0UtsIZzyulVwc3/W4B94vw/ECa9Jhh1P
         gRM12Ot8xjO+getevkSJAZY5kZFGkvTMsgqvR0a49oQUbUX0kWlNej7csdNjWfKFy4T9
         ptftZmr2TdBPLAKvp2Ws4LFFq0KCe6PsdQ1O/YDXgTK58D3tnDCFgGphfl1gWLlaA1lf
         khqC1L5965mqFQtZHuOew6XHXvFSrzSGazuLn3HyyQ3RPWcrYPfeFdnJNWWbAwk52Ud7
         6KE+WVVY8p3HPwumPyjoq5v0z6lcP1MKod8gXEPY03Y8XJGp/4ovhn2sAvnu/KxcBOus
         aEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=FQp8dTcVKx2mr1tR6WUahvb9pJI8FFzWBdRG+xCHQxY=;
        fh=rJvK1EEcI83CpsMWraPvDtzm9Q6iCFsLSkLPZsk1jfs=;
        b=hjvGn35iX/P8HN/wb3PGg3aG53dDlk79cwO8OjK8PMzJ6ndbUEg6uodS+FqxI6uGpj
         pqejHgBTiM3qAEoDEoVEIrOvDi2Pr7H1VE9y8fnzFdGMTVKbA0vEESxOgV3l/d9nXJ+E
         /neFxiCWCM2DSFAnh14LNIhdqU2omu9ct5Kho+45/frALO5UDh3kD5l6Pn8v+f4V2wGr
         T5vCJHjeex5oBfWMEU5n/AR6dql+ms47qA8Bq3r+y7J7p4s8gDvYfoCVL3rCR20+5lm7
         3fIf7BRGXZdyl1vA3V8+PavfgeuQ0zeKI+K0bG1pIgEL0pUDjRJlt94SfdQxNaH7Y2/s
         f55w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917149; x=1771521949; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FQp8dTcVKx2mr1tR6WUahvb9pJI8FFzWBdRG+xCHQxY=;
        b=ElgSKw9URYs+yn52mGRgB5l1EADqec2v39XzLX70/2r3DPZh5e9v2dKuKBD+LatDWc
         E7k0ouc5rHppj4Vxca+4IbTJt8nZgQJmw4ZpTTrZf4BOQ/JekNWQvyzwvQtP/+5GV0RM
         MISOEz7OcY7ylUKH1jrgsOeRZLNaUb3ZyzcgJR2aouGJt/TcsoVYXSZUisaJJb1QvwzP
         En0/OADwQ8m2CEjZbN8QvlC8ZRQNN6s6Xd3t/arT0JUpV0f4wO/z7mu4v245tXJLuuVg
         AYI1vqi470XKixQq9q6wejtSLC+w+QOfOMZqA5tRFBpTL/kX7RDQqcwL07bs4M5YaqnR
         2T8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917149; x=1771521949;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQp8dTcVKx2mr1tR6WUahvb9pJI8FFzWBdRG+xCHQxY=;
        b=nyzk9EdNgVJkVmRuqBzmJdo+8//sV0oQ6dfny57hhI87diFH9eilPqDTq/zz+4BAGs
         TasRRLCEsFp+CVtxFLs8TSkVUiUcP2/e/UxFrWoXfLtrn7ZnGKhRTnM7ITseu5AwXlWT
         nP3Myt9LB7C8Dy+GG9h/TPyzlT8/hBSvNs7B/u7zx4FzTf/VApL/E+a2QTcT00eD5j0W
         s26fQRkOvHdAP+X/j+ma1NAlK4oJmlWG1cmEy+AbcVGz/1PDj7MpFv6h93zcJXWohbsx
         zquvI+C6zirHY3RYCOrp6wo9tT1w9QEIut7ww8RZye1gOkbK0goiQ0vv/kgNU6i2MHF9
         YOWw==
X-Gm-Message-State: AOJu0YwRmHtVk72No5slxNN56/fKxQs3MQLZaMQTFiaSH8lW0aKPGzMZ
	p943ezwDr5rjME7enKHrvrtvQamHqxPk0udjvD3uqYq4//CJGim/5z2adXdus8RDhGRGCEmYeWz
	wSfToaQPuPo1IcSnl0IYt29yzWlJB19sh8taw
X-Gm-Gg: AZuq6aIJpvKYr5iGL2qvp2PhJ6LmI4BV2pUS+UZrhVoPuViBm8bOt0cKRYB+9F+57KH
	Vgtt2sdZXbzve+d94eHKJSY7YI6UfX6+WWeth7xVCw03Fg43o20H7ZA8ka7fDwZ/vUHf1YTlLIn
	RUuXm5ado9lyRE6bPcxgNOq6EPUUpFqYA5Kmi2eVV9OcGT+H+hxIsE2vlKB9DovqTrYTD7CY/cR
	SoblvDkT4fBbO/ccaFsnqNKSyBSIhEPtZ1243z/A20eNbuWa5FZRXC4zdnrd033fgy9Tjatux46
	kfJssl5DS8/8MvO3KS/9Xxf2Nt76Jx4kMAgI4u/0aaDM61HrtoTO7BnYnmCC7Su24V2yHFw4Iq+
	lfI2PgRnNTwcnH9RCtNgWRWeiYhHgUGApNNaUhVgR1C9INBKVnJyVNTpQUdMf4n3rUmnQWvcGhQ
	ahZ1ocOG9lK8ykkpntdw==
X-Received: by 2002:a05:6214:768:b0:894:70f3:5ece with SMTP id
 6a1803df08f44-89728d8797bmr49094166d6.8.1770917149593; Thu, 12 Feb 2026
 09:25:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Feb 2026 11:25:37 -0600
X-Gm-Features: AZwV_QjEUPy9R1cvwQ3jbdE-TRmzHpoZUY8lbbWMPWaRBDqKy7II09dFd47aHv0
Message-ID: <CAH2r5mtW27D0yFpr2QYkEnd+=dkE9v2jcYt2TS4Zjje0Ccwakg@mail.gmail.com>
Subject: Re: [PATCH 0/7] smb/client: update SMB1 maperror, part 2
To: ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Merged the seven small SMB1 error cleanup patches below into
cifs-2.6.git for-next

d6ce73d385fa (HEAD -> for-next, origin/for-next) smb/client: move
NT_STATUS_MORE_ENTRIES
659ab982f43d smb/client: rename to NT_ERROR_INVALID_DATATYPE
a7779163e5f0 smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
2dd078621dff smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
f0111fe861f5 smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
ad6347fc62df smb/client: map NT_STATUS_BUFFER_OVERFLOW
63fc8b74492f smb/client: map NT_STATUS_NOTIFY_ENUM_DIR


-- 
Thanks,

Steve
