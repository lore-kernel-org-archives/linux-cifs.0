Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUxroxbc"
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4E1B9
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 20:07:58 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50bf8843a6fso510648e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 20:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701835676; x=1702440476; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EzaeARIPaiJkUJcUPlup2jcHnpbVZqsinx3KQwn64Bw=;
        b=HUxroxbcVHLqNZnVg6nNgWysg2yz5PsftOEMUZL5PnImXYNrote8D0Fc92VROpOdJZ
         1aNOaaumwFHT+mMFhamTRXiKnMmRSvZHVqIhK6COkc1CvbdquHYU2vbPqvA7b9+WFEOV
         4rSxQ+KmupaiSlOj6L5qAMbA8XFou4bDwu3Zxusk2UCEv3/WZ0BgkBx4+eoUHEmqkQnQ
         QQCbqNOTudGqMGPpCTyowiv6LdPxS0gVUKe/QH3MqEmcNAfMpPF8nNNQYLlSN9wLSf3O
         kOPKeOCsdUaUvqhcro91FXCVIiGRI9INJ8NpbF2gM4JGSlA9zlMatCqHJ7h0Ufaav7wZ
         7QJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701835676; x=1702440476;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EzaeARIPaiJkUJcUPlup2jcHnpbVZqsinx3KQwn64Bw=;
        b=jIP+7eBeR0zCuGm3WCeFsNgumtbMzHj2qkXllGJf7asMrAwJwsj3PueYO+szQlNav5
         ZhCR+dpR1iJLksFr58G6yghKFkxRDeUncUKYkelu/0kPNEI+UbZLuguiXeMrm1Xyks17
         R2E1dh1TmL1IQhMpuK5jnFCAfDS8R7smQqA0wZSUIpDqun9+MIJeiwAMaxkE9HQoVQHs
         EqZI99tHJaLhFNoxKMcd0f9EsswxZcxIYu1tgdQd9yDbt+q/4k1glopVoxBIy+oTU5GV
         QGwx1pp3no/3IXUmYCpA2eX8NXIE3REH4WzaakcTV8RcH5rW8mlGk2rvPejuOnhC0vLy
         M/mw==
X-Gm-Message-State: AOJu0YwZFLyGyvxAEM3xGHqtPR1qB9NrsSJyzgB55WYAizawNpvkdBdI
	h6b6c9r+qYxxY7ewEmOLZYTDot6yjy+hy6MIe8A=
X-Google-Smtp-Source: AGHT+IF1X9UIChxywGASZwuyIvLYIfW5u65+GVT5OBmwXMxqv8cdMtD1Y1vpEFersAMsBMCN1QM0tH7X7zlWnCa1QRE=
X-Received: by 2002:a05:6512:304f:b0:50b:f55b:abae with SMTP id
 b15-20020a056512304f00b0050bf55babaemr131061lfb.16.1701835675603; Tue, 05 Dec
 2023 20:07:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 5 Dec 2023 22:07:44 -0600
Message-ID: <CAH2r5mvKStL60k-7hLezXzb7xx-CRUU7UinF+2oMRRk2NrMZXg@mail.gmail.com>
Subject: [PATCH] cifs: Fix non-availability of dedup breaking generic/304
To: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Running some tests with for-next (which includes the dedup patch) I do
see one additional test being skipped that passes on 6.7-rc4 (without
the dedup patch from David Howells):

     generic/374 0s ... [not run] Dedupe not supported by scratch
filesystem type: cifs

That may be ok, but seems strange - ie that the test 'works' in rc4
even without dedupe support.
The test is trying to check cross mount dedupe so probably good that
it now reports "not supported" properly.

Current for-next does pass test generic/075 which is good ...
-- 
Thanks,

Steve
