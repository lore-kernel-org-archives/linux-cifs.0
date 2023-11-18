Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LB5pso34"
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACB5B0;
	Fri, 17 Nov 2023 16:37:29 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-50a6ff9881fso3755792e87.1;
        Fri, 17 Nov 2023 16:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700267848; x=1700872648; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CxtVFoV3G/MmorB/F0YD8MQFUJsJvmktt5r+tHpZpZ8=;
        b=LB5pso34cv04SMV6nGtIjeTrlbF0sg+zwZ+GWScf0a+ms1WuM9RmVGpvodok80hosC
         87l0NYFPxMDHBuD46eznhlq9KH18vSjzJVO0VdFPPmIZjQH6gG6M2rYR4OpWIO8olym7
         qXHvWW52aM6OdBVs9w3INjJzIRF0NdhQom82hQTvDh1GKcOXHYdu0t9v43t/8iRvVL2l
         Wbe1AiMKxEdXrLnyhmOakawMewidfZwScluN2QnzMSKvrzECJbFFSPAmUrHG5uzMEOgk
         O2NQl1IWQo+pl8QdAyhFLog0D//5MqpWNWwjhSCuXKe7uNhYMUiEL7FaGcqpxfsyAWyv
         uCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700267848; x=1700872648;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CxtVFoV3G/MmorB/F0YD8MQFUJsJvmktt5r+tHpZpZ8=;
        b=WZLgcbdNQrC4fg6zeniGb7LKToyBTBt2pQPTzWWF5hHmMCZfptqvNJ8CfpVGN2QCWg
         gRa1YkYKwXJpLfNU2DWwu3gI6yoXnm9Q6yy7xQCYRGpi1F5nswobINmwFPHYEZGL6XOt
         ZtpzoYl4Fz+qUiCGjVqZn6m+jbOuNxbS8H2L9h5ARZFgGoj+aHe2ujqm/tGZouNj2O9+
         qQbZhfba5X+RqwlyoxhCnsHI0TF0eVdpt3Ib8TawrvgtMJyYaHziQJ89Juo9BmbsxYKl
         v9ns0X8TDskcHHk2GxKwkbOcsj6cc0DSw5urh6iTDU82X3P4GOTIyTNjtq96mviKQPjQ
         zyXQ==
X-Gm-Message-State: AOJu0Yw5vxvI9/7KGRGIwvmA7hSUqQQ8otaEqJ2wDVnPWZ44j2ObLsZz
	2M+xoEMTpdsGMhVSyNBWQATWwFmV0umitwGGYs1Jvggeiv4=
X-Google-Smtp-Source: AGHT+IHMVCa5N6+PbZh3LRTxQsaEaet4ICSjDflQIYHwg/nDji7SsWKQUqLoH9Mydml6avg9Xnfgw57zQTUiD5X3N2M=
X-Received: by 2002:ac2:4203:0:b0:500:acf1:b432 with SMTP id
 y3-20020ac24203000000b00500acf1b432mr720823lfh.63.1700267847640; Fri, 17 Nov
 2023 16:37:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Nov 2023 18:37:16 -0600
Message-ID: <CAH2r5msETjR-mEd6PUkE-E=OTMFKh-jD2ucuHP=uGyLScZQCLA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
b85ea95d086471afb4ad062012a4d73cd328fa86:

  Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc1-smb3-client-fixes

for you to fetch changes up to 5eef12c4e3230f2025dc46ad8c4a3bc19978e5d7:

  cifs: fix lock ordering while disabling multichannel (2023-11-14
11:39:35 -0600)

----------------------------------------------------------------
Four cifs/smb3 client fixes
- three multichannel fixes (including a lock ordering fix and an
important refcounting fix)
- spnego fix

----------------------------------------------------------------
Anastasia Belova (1):
      cifs: spnego: add ';' in HOST_KEY_LEN

Ekaterina Esina (1):
      cifs: fix check of rc in function generate_smb3signingkey

Shyam Prasad N (2):
      cifs: fix leak of iface for primary channel
      cifs: fix lock ordering while disabling multichannel

 fs/smb/client/cifs_spnego.c   |  4 ++--
 fs/smb/client/connect.c       |  6 ++++++
 fs/smb/client/sess.c          | 22 +++++++++++++---------
 fs/smb/client/smb2transport.c |  5 ++---
 4 files changed, 23 insertions(+), 14 deletions(-)


--
Thanks,

Steve
