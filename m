Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316D35C619
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006405; cv=none; b=JOU6cO04nOi7RbqtitosaXzx7XRfPBv/3NwKRulq3e/C+3bBbiLh1uIV8u5owhYHU6baEyoQNJtqmjUBqJMk23/QvpGNWULAfSHgrTYjK9fx8W8Mn8ANQSRN2TsvelGoRn7rOMiICIM4PbowqhxO6YMhQRERdwj1EP1wHP+vaXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006405; c=relaxed/simple;
	bh=JQSTHFDR1c37elA++MNhTRSruk/pHzzOP4LWn9GnsRo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gOqRTPAxpM9cEKIe+A5ywamEVRJkxALTtAhMuHjqe1j/RYjcI5mrtf19f155334xpYyX9IpMWbmycoLQyyOGE+aMaVi4scol4APqiUzP3kxUtbeuxxAp0f6aJwf3S7j+6kYexYgTBdFW8rukDc6FH7or9yNGiP7R+VCQ7dQdoLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YcI5uUfk; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YcI5uUfk"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40eac352733so21941075e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 02:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706006402; x=1706611202; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yD2GbCdgEIWjxWXsab3BhcJqAvRb8rzL8CYAAd6HPaw=;
        b=YcI5uUfk5EvEth2QQPeYzYEHtyJLHf0AtXIiqu38KovmkOjF9xJ6UM3Y04w4P2uZGf
         jHiQ2gobVkQ71cCwGfv+0l0OIb7ItuFE+Up+1bfU+OdXyGuzOgNW7Pa6c//tfoCRZ8rj
         RnCT0+oY7TFMcwTiQzC6W+i/95iQC6TsMIapDqP55cLad5zKplZLb+ec7xNNLbOWlIoq
         US+mqB0sqK3BMzjt9q/A4ZNgfczgGtWJWEkh0YyvuSOJrUmPwBAilD2WZjZQoBRyWW7f
         JtUxMzmD1jInnn5t6KxjSeo8FRRM1ZdVoKAEh0JBi3dOvtCXc3S18Z4X5WPgrC4HEwMs
         yrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706006402; x=1706611202;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yD2GbCdgEIWjxWXsab3BhcJqAvRb8rzL8CYAAd6HPaw=;
        b=XqhxsrV5TZrp9NJM/w0cfnAsN286efIAnnsXFj3Op2gJb5nOQi1SJpU/kwjuP//Gm+
         jhumj6aolJ7p0r9bEdTwV4a728fDY95qqhcviTqsyj8uFstddoE4vmHSSHFfpSfefIEI
         vBC6gI3Z1jsnpmyzRS56Ozpg6IrxClnkC5R8npTrlzsNBx3Li0KHkup3cDBmiv2aXQXQ
         rcDVXCnK8ysTjuFsFK0ysOE036+tiCTo7KKPimo86UBEzmbXGmwzxdTif9urlWfx+1oX
         1C13+DkQEC0z8QpsoNPRx1+8zaeTwFBQusrLeMYOfXk3SFqO0aok2prvBZb4Jq/rw5eV
         Wl0w==
X-Gm-Message-State: AOJu0YxWSiU85E1jNiDZe6ECiT+EP1yDc1Ggapp+1JCWiGy74C036rMw
	YxOl2v672bft98YQplg6UpZxsHotiRW2R3HYbt/NIUlUcow2IUPOfHXXXbMPIQ==
X-Google-Smtp-Source: AGHT+IGyVyIr9mu3XFkjTWDsX9mOhMxiiN0Y+bFE6O/XK2WbbeZ+b6Z2h/1XO+Dx89vCP6Ou3X3bdQ==
X-Received: by 2002:a05:600c:3111:b0:40e:6334:fedc with SMTP id g17-20020a05600c311100b0040e6334fedcmr368516wmo.94.1706006402171;
        Tue, 23 Jan 2024 02:40:02 -0800 (PST)
Received: from p183 ([46.53.248.133])
        by smtp.gmail.com with ESMTPSA id r17-20020a05600c459100b0040e88fbe051sm22163894wmo.48.2024.01.23.02.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 02:40:01 -0800 (PST)
Date: Tue, 23 Jan 2024 13:40:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: delete "true", "false" defines
Message-ID: <e7b45a71-c973-4672-92b4-490864fdbe26@p183>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Kernel has its own official true/false definitions.

The defines aren't even used in this file.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/smb/client/smbencrypt.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/smb/client/smbencrypt.c
+++ b/fs/smb/client/smbencrypt.c
@@ -26,13 +26,6 @@
 #include "cifsproto.h"
 #include "../common/md4.h"
 
-#ifndef false
-#define false 0
-#endif
-#ifndef true
-#define true 1
-#endif
-
 /* following came from the other byteorder.h to avoid include conflicts */
 #define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
 #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
