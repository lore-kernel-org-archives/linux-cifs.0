Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2A38389
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732283287; cv=none; b=YbqPhWzppJGrk8xSc5WM0lgy6wGFU3y/WvhN3JJqDLB1ClSStEWOnTDWoemdYu1uVvyvk0H2SuhXs+qTzkPTPai6b0Erc+dVbx6ydkxtz3okILkBoBd2cF+gYjwW1tnrlKIpuNsvugJwcvQKPtR34YyAUEj2EZtwkUrtEq0ctrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732283287; c=relaxed/simple;
	bh=xLsqLKXyflL3iqJ3OR4KfCmKz8lZpGdCJ0csyXlgyn4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=anb5uriL/Eyb5FZxadiMX+UZX7AIGYD/ljnbBUdd6kXpDHb7uR5zx7plSnOOZHbtqeY1HVgnJGakDdMCE3i0lwHnNABDX6P5gmi57dzjPK1EopHEgqcoYBZ+sO40XU2hlNo9creGapM7beeLkzpbwl9rVJ8BTmIYagVQwLIzFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b=YB2x47go; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="YB2x47go"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7f43259d220so1628034a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 05:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1732283283; x=1732888083; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kX8zjN9HZsxJivLuZMC8m08uGvhEHanmac7yvNFGAmU=;
        b=YB2x47goRyAY+oo2IsLeAHzw3NSU6quSpfvhvWFhauIn/bE7Es+niyl2R6OZUAb3ON
         vANCbnxsCUuIKR7Zd8z5x8rd5SRvN9kAqox6LaB/5+05lzUSuvIo57OeZl6uYRDSnXQu
         alZMiLqptojdmFHM5RzKYddeU31/7lHntoV30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732283283; x=1732888083;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kX8zjN9HZsxJivLuZMC8m08uGvhEHanmac7yvNFGAmU=;
        b=IGgXZ+3kjPhfcftxP3E9R/lT5B3uVF3PKG6XvZM5cOI9RsTWUrnEVxobkbUjq4wlvP
         m5+1a0epMXoVOY3aVJyUAGheKGw2J9/j0fdsFQK+BfqCiDQokaQTqFTCs/L28td7zjjQ
         BZ5bgE9/C7dwekPb+HBD6zAgi9Oj91Fr68ARVAaKYgoCyJNJWsBWIlirSfjuXzLILlzI
         xZV0PA3xE+ti6qylnE0FqesS0FejEmq8XaIVEqzr3srzz7tHTIpHF53MMVdDRoL8J4De
         ooVBvICPxxOJZXcQj3fuKHoY0IiQwr7kgaIgoWdmoMvxIOeTlyTID0Qc/t+Mkm+BfS/E
         22VA==
X-Gm-Message-State: AOJu0YxnxyanKM5oVn6WsZCm+rlS0agF165bkKq71aDdxpih7hxnlVT4
	vV8vImSouFLreHU0UQJ61A3YB6KkK3/exv5jKjFryV6le9hIKkRy4BY673gjOXS4oNIJ9Thj5Y3
	U
X-Gm-Gg: ASbGncvq74fCwPda1oLwjEYtRw0/8uvElfPAN0OqGJAlWF+RDqBd2f+u4qj66Vc2pM5
	sWiU2/DkRUbKPZgGd/KvUDxruOFgxrootYJjT1qayHy7A8qQ76cykFpM6hjj0bVCBzdKpc8Ob3f
	/W+ndnFKtHtf/BHC0ex2PCiszAsaEFLl1a3kUCqwhHTTqnz4sNijg6g+++jApyC/F3v9IDgGVWE
	pg3pAJ6By9qb/6IkQgWLXSUZOUYQv9YFDYVpxkHweUPxIU8
X-Google-Smtp-Source: AGHT+IGf4GF3EMKAyi0aKCYWX1bi9JGTI3W8le5up0ybfWL5z+f3Z1vBlHXrf25XrxIjuLsYykx6Jg==
X-Received: by 2002:a05:6a20:1582:b0:1d4:fc66:30e8 with SMTP id adf61e73a8af0-1e09e3f0006mr3628871637.10.1732283282753;
        Fri, 22 Nov 2024 05:48:02 -0800 (PST)
Received: from 6f91903e89da ([122.199.11.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724eb65d2adsm517708b3a.159.2024.11.22.05.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 05:48:02 -0800 (PST)
Date: Fri, 22 Nov 2024 13:47:58 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: pshilovsky@samba.org
Cc: linux-cifs@vger.kernel.org, rudi@heitbaum.com
Subject: [PATCH] autoconf: drop obsolete unused stdbool.h check
Message-ID: <Z0CLjvaXbBhhogDU@6f91903e89da>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

With configure as shipped using GNU Autoconf 2.69 for cifs-utils 7.1
configure fails when compiling with -std=c23 (gcc 15):

    checking for stdbool.h... (cached) no
    configure: error: necessary header(s) not found

Using GNU Autoconf 2.72 to create the configure file does allow the build
to complete, but as the HAVE_STDBOOL_H is unused - drop the check entirely.

Link: https://www.gnu.org/software/autoconf/manual/autoconf-2.72/html_node/Particular-Headers.html

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index b84c41f..47c6069 100644
--- a/configure.ac
+++ b/configure.ac
@@ -127,7 +127,7 @@ AC_CHECK_FUNCS(clock_gettime, [], [
 AC_SUBST(RT_LDADD)
 
 # Checks for header files.
-AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
+AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
 
 # do we have sys/fsuid.h and setfsuid()?
 AC_CHECK_HEADERS([sys/fsuid.h])
-- 
2.43.0

