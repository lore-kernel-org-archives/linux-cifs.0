Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jImzH38J"
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76090BA
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 09:01:40 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-50be3611794so2613503e87.0
        for <linux-cifs@vger.kernel.org>; Fri, 08 Dec 2023 09:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702054899; x=1702659699; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hx+KXbsrDsXqQ/asxho25qjSNIITqY/mDTMJmu3//Io=;
        b=jImzH38J/NbFS5nXcgNlLo7564ZCcw3kCl8PGSEuHh0JJ3qaxBPabZ+yscoVOpmPIh
         7diT1bNCY6YOtmJN5jhg6tiLRP3txb5Gytu8RkdgXZDNAhrfO2BCf+Vu1MDT2rUXCuis
         X/n9hVB2Uauex+2RQ+nuulxfs91IwgA601Fw9+UlRc5Z1KpYP+lFY6tz6I4tL8+pC0BJ
         vc7MXZBD9kOZkDs51Gi4grtJRYr+tEeEtpqoTxa/Pe7+nTBoBC0REpYrhQ1j2cAwuM6r
         Ho8peEXDaZvtsIHiuB1t8O8+1WHInjySArBtkBFkgrUaPy/M201UTao/9jdEjZ6by6Zy
         HmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702054899; x=1702659699;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hx+KXbsrDsXqQ/asxho25qjSNIITqY/mDTMJmu3//Io=;
        b=AnB2ILjU29Ev7j+WQj465Tf1yvJ28Bzr5xXChUisquHkdLnlbLfqI7I/fkUidOmd3f
         WDTeBWK4m4KO2wjx2va2TQl4KrT/JZ3TZUW73+QudK9Ej39dBS997YwuTBdunSNTBOjP
         SgGtCVgGSSuAjxY8jdRuphTn7cEIf/BtN4W0+z3QpiNyd4TIRwnySLd3Qy6yCcdVCD9Q
         4Sy8flK5lkz9EsnUydngB7TDh1iXtBCvtTSmZF9CeH1G1cDm0PlxJonpTtHSvgvlGBgI
         jo2DE0v2ZvqGqDNgItDMTbotntnB4iFrzQ+YicvjksdtDkEohVS1IPLISzqNbAfTkN97
         2zZw==
X-Gm-Message-State: AOJu0YxRf5+RljVXs+cyivkAC0P+1HBeJIBN1babn9dfnQSQoynRDWmx
	k4XwcipyGKDMfIavyUI8ezoOsx8jEZX27rXO2EA=
X-Google-Smtp-Source: AGHT+IHWoPbuGSShxjR5HvyR57kAa14AEktbOwWC3/ZYoENSvlNd1Q8kPjNtjFOpN0sqDeJapBz2dA1iUIWVEF7vi9w=
X-Received: by 2002:a05:6512:2350:b0:50b:f798:28be with SMTP id
 p16-20020a056512235000b0050bf79828bemr115677lfu.92.1702054898254; Fri, 08 Dec
 2023 09:01:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Dec 2023 11:01:27 -0600
Message-ID: <CAH2r5mtK-JQeH5gLoGjUS5sywfd-KTJhnF_Mf4c+KCoapMEPhQ@mail.gmail.com>
Subject: Lease keys and hardlinked files
To: samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>, 
	meetakshisetiyaoss@gmail.com, Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Following up on a question about hardlinks and caching data remotely,
I tried a simple experiment:

1) ln /mnt/hardlink1 /mnt/hardlink2
   then
2) echo "some data" >> /mnt/hardlink1
   then
3) echo "more stuff" >> /mnt/hardlink2

I see the second open (ie the one to hardlink2) fail with
STATUS_INVALID_PARAMETER, presumably due to the lease key being reused
for the second open (for hardlink2) came from the first open (of
hardlink1).  It would be logical that leasekeys depend on the inode
not that the pathname (so could handle hardlinks on the same mount)
but that appears not to be the case.

Interestingly the case when two clients access the hardlink (or eg.
nosharesock mount to same share on /mnt1 and /mnt2) works more
logically:

1) hardlink /mnt1/hardlink1 /mnt1/hardlink2
   then
2) nosharesock mount /mnt2 to the same share
   then
3) echo "some data" >> /mnt1/hardlink1
   then
4) echo "more data" >> /mnt2/hardlink2

What you see at step 4 is the open of /mnt2/hardlink2 generates a
lease break of the (deferred close) handle on /mnt1/hardlink1 from RWH
to RH, and the open of /mnt2/hardlink2 is given RH then after the
write to hardlink2 you see a lease break from RH to none as expected
before the close.




-- 
Thanks,

Steve
