Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF60A7485
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 12:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748867120; cv=none; b=fiQ/lHX99lNxLpWKh8plK6mxO96M8GCL6YgKTs7Ov9CfHTlx4Hx7LD2kMcBT5U2vgZo+BTIsHRR70s91LStEUBvZhaBg26VMx2jdx5NYOaimzjOQ+L8ZkeHbAxSLq5MRFx9z3n7RqqHJwFta3Me7oiIP1PFWKS+DxSGA1Cx7j9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748867120; c=relaxed/simple;
	bh=d7O+MS5TqzvXiajV+UI6S8f9GijHBzn0j6T/WYvvrnE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=VfdP2NEi7yf3/iv8WsCekWsyu+w3bLoJL9rnXRPWInBzUD34eL6KWOf8WSvMKkHJ5vakc+T+gYOtNRmxLN1/lgzeBYi+6m7d0CQLLYSxhAxd0F4fGyWCqcUkTeJaIkW1XWs4uI8Lor0vJ4Obd8pk5LYxAZTrlEn8Z/Q8W7yMX0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SYGWzFyB; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SYGWzFyB"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e7c5d470a8bso4048109276.0
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 05:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748867117; x=1749471917; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J5J/0tP+fuROFPPt8PXJJj6FJx09x6JTSI4ejMNpdkY=;
        b=SYGWzFyB2nHazggprnAbluGUI55r6boRe8ur0jYjJGYrsdxN1Z8rxbzFaAsIT03ipz
         hDtBAD9pWEQczRnx+iMzHCdquPIRtJjVFizlE5F9iAXxGJ2nKiUpMS8c9/PdyKH1xJJF
         VEGMy8cV5ZORehtAnl2P1LKKpMG5WEqZjbHo6vBF4tmE+YysgBu6JF30tqxxvCzkiPSE
         +1dr1QXYsxpPsRtlNz/rsNXkfhtMxbTmmJwRcn9HXXDDeS0XH2JJEofRILTXubf6lk4d
         G5UCEThWXjs0Gir8dN6xU3FETLw+s2H9Tm78VwJtMYYU8slvW2FjU4EJF4TBjQfHZ3Qc
         EeOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748867117; x=1749471917;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J5J/0tP+fuROFPPt8PXJJj6FJx09x6JTSI4ejMNpdkY=;
        b=ww8GNoyT6zQJrjtXLAifG/RQB1OgmACI+3iQtAZ46Mk3EdXkRXCEQxKiLVqk+dqdIT
         azlCAhx1Fej+q1JU+AkGphgA9eFnND30LMZbrgM8iOIR6lWYxG1HVxK8NcDZ6NQTJSIC
         irSPsLGVX9aEAN9FzX17NnJqfUNVMnBFoeqDF91XLwULz9o0E1Yw1oTyzuHTYqn6ETPu
         vjqb1jZyZA+0leAfdd+ruBAPkr/SBg7ULhLSl0gtv+1KocOQ1JmTodLK6hbAnwM3m+k1
         8G8AQzrj9UxThzi0Lp4wIRtNQmM7kRxIF0JyU0AAlZr3ZJusvMCSxtIyGz32ZjSIcKpy
         QIVA==
X-Gm-Message-State: AOJu0YzfLA5FGVqC5SdNsaE8jOg1VazcZ0DXtA9cdLaMNpmj+9KPclKv
	qRPr7j9AZS34n+ZlsSSlhjEfnw4eHbEd4O1CP8WwCSMq+apnuOGHIro0yWSsurH1B+Sk0Ae928+
	aAKucuWhJszY44JdXctOSUoCNQmo2LkYrJBoI
X-Gm-Gg: ASbGncuAjSTwkBJ4nWrYvGr9UmZ5JE/eVHkuNAqpnyoIdAEiZCoAq4cJ0bO9zmWlm2w
	+Ca1XESkJCDBn4HpkZpXQPkTScOjft3AljovsFc4SeE4kV7WXgNGq72mAdViYCfMUOsf35zcl/1
	nXk37frHr5P/E9pGt171sq6iH9eXPHIA==
X-Google-Smtp-Source: AGHT+IGe5huMthoTV8Jozut7n4S19AAfRJLKgRrbxo+itjYOCR8Bd1O1hpsb0dM5KghhJ0+oKROOJE6RPXo3U2ujVXg=
X-Received: by 2002:a05:6902:1505:b0:e7f:67b9:1176 with SMTP id
 3f1490d57ef6-e7f82094b51mr16845186276.21.1748867117509; Mon, 02 Jun 2025
 05:25:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Maxim Suhanov <dfirblog@gmail.com>
Date: Mon, 2 Jun 2025 15:25:06 +0300
X-Gm-Features: AX0GCFvPBLzTmOTV2s-Yb7UBCsWqGkMqjxx26cQ0mGG26j43HZCL-yMG8c2QdqQ
Message-ID: <CAKeu6dXUhLP2cjagz_+YB2Esf-rnj3RQHWaX96R2bEBOk0C6dg@mail.gmail.com>
Subject: [BUG REPORT] smb: client: find_cifs_entry() suppresses some errors
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello.

From fs/smb/client/readdir.c, in find_cifs_entry():


cifs_dbg(FYI, "calling findnext2\n");
rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
                                                      search_flags,
                                                      &cfile->srch_inf);
if (rc)
  return -ENOENT;


If 'rc' is non-zero (e.g., EIO), the error is turned into ENOENT. This
means that:
- If the SMB server encounters an error while querying a directory,
the corresponding error code (i.e., STATUS_FILE_CORRUPT_ERROR) is
delivered to the client.
- But the client "translates" that error into ENOENT, which
effectively suppresses it.
- A userspace reader is left unaware of this error condition on the
server while listing the directory.

I suppose that we can change 'return -ENOENT;' to 'return rc;', but
I'm not sure.
