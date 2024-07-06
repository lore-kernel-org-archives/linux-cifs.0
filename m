Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64E134A9;
	Sat,  6 Jul 2024 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720302991; cv=none; b=o9XDqPu8+8UZKZDQgTA9PnBRN/7SuU6fuTWJJ5soZmKYGD+6j6rZ6XtrHqccfY2cBayxU1aJ+w8Q9CDGVUIryzZH8bnNSAkn5gffrK0jW9Sw5wNU/gxmTFVlIahHvJ5+CKEVPu1Bhfa0m1gkwv0+gMik3in3vSQcRPiWjuAVyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720302991; c=relaxed/simple;
	bh=WZgF/zUF0x+goro8S5vqnV9fMEAqTuwEuLHUb8DeGSU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dnea/ZhjFBKskLGWd5QuRwUYJO9TVNdZHVoD3L6ZH8HTNbhAMlKRX3mBby+OWbtI5z2rjf9ym/f7B+Mm5KLH8CkYH5GBI/MMk17BvIgB5ZX17rnmPA7Ntt/9qRbkQvXimEIG9FHjxco4zY7RUiUjHgtqA1dAU9ZRCLeb5LSvmMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAJgunqd; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAJgunqd"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so4449440a12.0;
        Sat, 06 Jul 2024 14:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720302988; x=1720907788; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UCkRsEz/Hi+9xWaaQEALQU1IZhkD8tAgiBdSpUaWA7c=;
        b=UAJgunqddPOyRLmf43gnWCJnv13WjsZWm/dyLHID61bmooAfZXVLOHFc140gWBf+N1
         4kNBZWvca87tQMZntStO619hmEXXbd9dTPdLfRHP08+DEiL8oijgj2fwFrkSp1lmfiLg
         guEOtmfiVbw7L/2kuun9eA1BCnPivU7BzCVOa7hKU91VJSUr+gCj1DjTnKfW21/skkId
         duBqOBi0eg+S1ma4xu8GU8snIINIAtrxs/rEmZ+XSEq4Gxib9l9ZQxy+Rk+wBXI4Wv/H
         i9nbkm+M/uJ8d73EmpoQfburxpKlweSNSQHnTxJAl962GtqgUd0NkpuNu56Fxmba/avp
         N/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720302988; x=1720907788;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCkRsEz/Hi+9xWaaQEALQU1IZhkD8tAgiBdSpUaWA7c=;
        b=SWYqn0Dw5behoanQ836aHq9knocJnF3caRGWMx3KB+4CyIMUSeCrjAgQX7zTx70eOI
         PAXGeRPoLRoYdTsEMu3jrpS6Q0UkmwiVvqwxlsn0QBBP7qQ64NTIIZP/RmbpS1Wnc2o1
         I8oVrgZP1I61P/0dSi8wV1XncsKrbDaEwSlEPGRVQD4CCQAX/Ig2qnWSUbgSjOcaEJMt
         OoAfPZRA32gpvRUMNTi71+ehtod2ssfMqcFBa1QIDaeq1Cd7dmRLawRiJXv5xzFsO0Up
         mpvhGOqc01+FpGpHc71pgW542zgCs026elumT3vKx3ZuEIRqEDTg8JqIWsdD8muyCK7e
         rs/A==
X-Forwarded-Encrypted: i=1; AJvYcCXHkMjLI0q98xMNz/I1G4l2MEFq+JC/MKwwZX5lA8EAwQIqRDd8IpR8eDBtw9ag2SIF7nxdpVc7ZXvXNl9RpY6z0nGRLiQKYlkquw==
X-Gm-Message-State: AOJu0YzeBnnukuuB8YQkHe432niONxetUFXBUYZg7ePIpJHc8Dt/OeE+
	pg8jC0GCksXXA8YP+ONQ/iCoU+e1Pi3rEmaWS1SoYsxOje+2ICn0eyapTr2U2pRHSiCQOiDk6Wq
	XtJuX5E/9Axo9RjoqQBeQl+B0yTWZQCI4
X-Google-Smtp-Source: AGHT+IGqRqLmmpzEaFzFVcF8tyAF90AtsEgaTnGIHqL6oslRNWWRxNuIdyp6r2Dxt+ZH7ADHEDIKjr5ivlDSFQ/3YbA=
X-Received: by 2002:a05:6402:5253:b0:57d:3ef8:614d with SMTP id
 4fb4d7f45d1cf-58e7bfb5842mr5164319a12.20.1720302987912; Sat, 06 Jul 2024
 14:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 6 Jul 2024 16:56:16 -0500
Message-ID: <CAH2r5msEqt_4VmncybOWBcADS96cPd19NjJnhtpkF7eMnAsSuQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
22a40d14b572deb80c0648557f4bd502d7e83826:

  Linux 6.10-rc6 (2024-06-30 14:40:44 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc6-smb3-client-fix

for you to fetch changes up to 08f70c0a930c00d25015fed7e3b7c5370d60be24:

  cifs: Fix read-performance regression by dropping readahead
expansion (2024-07-02 21:23:41 -0500)

----------------------------------------------------------------
fix for smb3 readahead performance regression

----------------------------------------------------------------
David Howells (1):
      cifs: Fix read-performance regression by dropping readahead expansion

 fs/smb/client/file.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

-- 
Thanks,

Steve
