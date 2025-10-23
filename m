Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871C8342CB8
	for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761238412; cv=none; b=N8JlhVF5I03F6zGLRK7EDwO7Yl8RylqSq2uMr+YizUTwYh9o8WPZ22aEAuxN5Ef6S5ijWmkw1GpWpl9PvCVkCHm1BHvYsf78qK9kdzc1xiULO9C+5XyszVrUoYsfpMZJLfk7A2bX7LuykbKjI/D2uF1VCZO+aUKogYFvEeJWNWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761238412; c=relaxed/simple;
	bh=SdwvXOfFTlTIkVhxUiL4GVChGR3PwqjX+ds6xLEUW8c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ZGvVJWoBNq61Y8DWDI2LfpQebcm1/vCEo1BM+MXYfamLJRzP3hJkasFeFR0uFdMN1/61wXjnLw685lfhZKKWVRoEyUJnqGSULZTwzcQqnK+LYlL4g3Q1ZbtsizLkj7CGP6OsfW9aBbr8jpQ9VlAr7DMCZ3kFjdBGx3ou+l2P0O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YthhUwKq; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YthhUwKq"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61feb87fe26so1858722a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 09:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761238408; x=1761843208; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=705h4iWOfZWGcDNaHvfZzI87/t6q5+VwuJ+oPqlglQg=;
        b=YthhUwKq+HTddyXuhMSnV4u21Ajnwtia24dJj0SUAMzAyJ5ECQZwUjd6+4rcVQvvBi
         DCX/fsA6ii9YsR6Hteyh9zyuGum9fMJsiiRTQuM6GO3c/fvUUAD8JVxWamM6m9Nx2eIL
         c/XLTbcAHiW14rJAMjtYPYilB4V61oyqsfVEwqjFpEKXNGgMDcoipJiTOAi919V14uk7
         SZaoYbnqjpKHfsjl0vJY7I4xglUjq6ubdTHK2rCLmjrqudTO+iJzXIhVrYnuqzvWmDQH
         ghNrIHrKqUjAq7wYzfSr+EMqJrZY/qfZu9GnV2aBOxaDaeDbkHAln1ukT9HULWBR1Xh4
         hZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761238408; x=1761843208;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=705h4iWOfZWGcDNaHvfZzI87/t6q5+VwuJ+oPqlglQg=;
        b=IPLtjg/eseY6glW6ruflDg4RLvu6tckbRt7uQyefe929t7DkJcCgXIJm0bMbuQjqxb
         YY2P1aXdpJSRy1IbFosUqgBfMiZ875Hf2/0P1lztLdBQdCZ0N0iDRWhJgkqJVrWqHeE3
         0mjXH51kULsQNG2ybWcxqnFzd9yKLBY9twOqQcZzls+guTdhfU1WwE6uWCL4uj+C7mqo
         x+GEXZglzwgdYso1AtljMW+HONyFQedY54pBWF0hcoJsmWf/e51WoNklbAJ18zbdsw86
         zmP7wcUzUNatJ69mxCuztXqy6+CnhEYbBhT3YgQ/lXAUv+RHnlEo9zGPIlTWUDL+p1No
         QHSw==
X-Gm-Message-State: AOJu0Yzd8kIZsiMy6lC2IGTZ6tev7/cg3fP7MbdsyUoEC6CBRBaycYwE
	0kods9OPsrvHmY2gGwo0L5/PWBUpLMsvhqwiAvejTaJCeeT74zBq0kQJDI+eWp//h1rT7zK59k1
	k/dFI4dsusvMv51hnioWZIXmPOypJ7LP3EDYJ
X-Gm-Gg: ASbGncsKNB+OP3nb9Px1MvmaKd7hSVLWlHe5wq1yEHuLi0H2W6bMCLSuNQAi+QM1knr
	D67yBgXiHArHJUTkHEUD2ZNPs1gsROSW7k7kov+Cff4GNVN32DCgT0Zy9BZNJsgfk+B4484V2I9
	oUWQ7d9mW2o/1cMbNL1aefp0KO3HvJQutAg+sWXlU/ri+gTwrJ7TrwpOI3b9KkcmZoo9zvFzMs6
	LAQHGCLS0yS+lQHKkZmT0dM8PYAl3PtUA3vHYDRHcLTC0lv8vHU9F1ycvZLLlv+lXc80Q==
X-Google-Smtp-Source: AGHT+IHl7yy0MQ/sKIQCJf602e1QNmQxcDNK12uE79IkBLrJGp56zc67lOuxOzht5KaQCNEyIXLN7U+tCwWQtafAy5Q=
X-Received: by 2002:a05:6402:27cc:b0:63e:155c:3ae with SMTP id
 4fb4d7f45d1cf-63e155c0587mr8947472a12.6.1761238408263; Thu, 23 Oct 2025
 09:53:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 23 Oct 2025 22:23:16 +0530
X-Gm-Features: AS18NWChi9n3dU-SnGKznqoN1onyYbEb3D-zUt_KPnUvDb9b6pegeMmPbl4Wijg
Message-ID: <CANT5p=oZ54hSkVL7-_oRQgN0FHxPKPoivgBD24sjNExT_HdETA@mail.gmail.com>
Subject: Use of cifs_sb_active and cifs_sb_deactive
To: CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>, 
	Jeff Layton <jlayton@poochiereds.net>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi all,

Does anyone remember why we decided to refcount superblock using
cifs_sb_active and cifs_sb_deactive whenever we actually need to
refcount the inode?

For example, cifs_new_fileinfo calls cifs_sb_active and
cifsFileInfo_put_final calls cifs_sb_deactive. Similarly
cifs_oplock_break does the same.

A side-effect of this is that when file closes are deferred, cifs.ko
does not get the kill_sb callback from VFS during umount. I think
umount simply dereferences the superblock and returns success. It's
only on deferred close timeout that the last handle close drops
reference on superblock to 0 and that causes kill_sb to be called.

Based on my analysis, most of the xfstest failures that we see today
with ENOENT or ENOTEMPTY are caused by this issue.

-- 
Regards,
Shyam
