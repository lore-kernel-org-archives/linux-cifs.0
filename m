Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F6324336D
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778873510; cv=none; b=L0c/ciow83VhpaHZT5crNEG0rjTVh3/1YoZCVP2xFeDpRQLW8nEBpyucWCVYjEchfjdPniQJ5yt6m6M0TQMILmtlS2kqR1+zRA+TrNrkqc7cAGQwL2YK6pMfDVVrQWwXjCnpbaFf2ag23ED/NvJOgkAbwFzwfY80jT9zFNz18qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778873510; c=relaxed/simple;
	bh=x30wO2FhwyPK4fF9T73E7uFT/ppNy/M8P5Pz9ayv+14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl81dEuWa7Ntoi5hiGuKkQg9KXp3/1RnEua3MyDWXWio1bhscwo5iNkb99f6aCNeIuYaHFkvmCqwhb80Zxchj1MXM39BOLMQWxRDc9Rfr2lWxewZTlN/8F5RfPwUH3gtto4hc0Aol0nyXdMlk9mNjPaNG+INauCNCY79hswUDPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftTQzxtN; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftTQzxtN"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8b4eb1fd5d0so2106216d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 12:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778873508; x=1779478308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZwZ1sbOq1osboJiviKs99QuPcaN2fyHvMmUqI3TItE=;
        b=ftTQzxtNhbz68/DMbVReybKdWSczG09d+ZHS2Jdz7BnquKEWOnTZgeQZmGbWs3ov+J
         gi0nlASZezNqijmB19KT4lTKUBqrQVZDVPtGnKF5cu8CdMvQLTHoGaJvGVJ6doZ0+UVv
         8mW7WOFeE6vuD0BBkkeGJrl4UcBlUdzvZ8LPU+BtG80VwBz1We44X+vbfwApvtLRi8p4
         xn9Z1BLjAG3dJVviKF78DwKeLczHIFYzVug0g2Z7NIizZ1mJen6m2UE6AgSpLkuKyGa4
         t9xKXdq/3vetsyloabj+Na8oldo39KANEQb2YIbOPC7yq/dvKUt4oqXx/gGw58Hxid+Y
         m1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778873508; x=1779478308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pZwZ1sbOq1osboJiviKs99QuPcaN2fyHvMmUqI3TItE=;
        b=dMkZ5M89YrDcFy9LZVRt/sf4+eWaKxIMmDpqZpHVgF6pi0LzKW3jBd2b55907gOF0+
         bd4tqeopXO/eypiGxjXzrQatNYoLyuJTutyDvbHyrgyru9EZ5dlHxzJ01/Q+ZdGFqvaR
         EiJN2EmavRk0vhVkaKZR6r2ZeWvSu5PkKeq1CloM8A2seBVhEd1IO1LS4tdNoTV2Fsb4
         sVVOsRlC7pS/FXGwiqgDY9eHQzvxjKD4NBGpYcjfKljW+6xMD7FGnDgU4a1rN/kKkgmX
         1uc0BTozmpU1dHvWgcObcFqipNPxylS5KkjBa5ch5OXXBnGva9ov23QvzH4u0mZ577in
         ZENA==
X-Gm-Message-State: AOJu0YxHseNileEjCJnasvk1C7QNHmkfGmCIxRnwby22w3dVocGL7JCv
	A7cFPKVKoSUskKvRwhjudrHn2MxVMSo9jPRXpijqUSjrmclOA3BgXt1zCEZyG4x8zktqhA==
X-Gm-Gg: Acq92OFE1w+24ZAR+HTg/pVdjimoqtw3Oxh1ohK5vbZmMnShsAbpgC4dQy64p5d7+BW
	f03Cj/6ggahtNKlTt9fpYIPglhXlk4zPsLLB7yG5ZOsEylDGuu5mKkSaP9IW0VzUHJM95D0MTya
	gWqA4Sy3Qiu7QzhKlbiTsHLvWZqs4NuaclvBrfmzuiN/H0MJgjMtoXE0RPSRv7kVFyzny4guPcB
	6OVkomtW0ATVgCQ/e1YWDq289QgMMnioV5GoEKONnIiyH0OITmblmj1+g2YDrw3kvpcXWTcu4pv
	thaRb7dbF0ApIh79Ld3UcNNTN+qv+Jmn2uvzPKxg1Ww2c3O6FpG2q43hBwiRvNnLpGk7h67vDjg
	ny8SQmZ6ajyyor+bZHHlv/kRJilHJqvFcoPeN91tjnHj6AshpR6tzfVjUH3r4mX1ClLoYPx426R
	O+A6xUjpKr4rNjB5GpUPRyY61gbcL2o/91ohZY2TnBLWp2a0+lrp2QwflYC0KjMKWvdrpV4Y/44
	2WuIpowL6khP1I=
X-Received: by 2002:a05:6214:2f8b:b0:8ca:10c9:845d with SMTP id 6a1803df08f44-8ca10c98663mr92214146d6.31.1778873508135;
        Fri, 15 May 2026 12:31:48 -0700 (PDT)
Received: from jeremy.kali (srv1619992.hstgr.cloud. [2a02:4780:75:55a3::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90c165434sm60542846d6.43.2026.05.15.12.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 12:31:47 -0700 (PDT)
From: Jeremy Erazo <mendozayt13@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: use data_len for SMB2 READ encrypted folioq copy
Date: Fri, 15 May 2026 19:31:41 +0000
Message-ID: <20260515193141.542623-1-mendozayt13@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAH2r5mtBCP-sg6f3RH3RxO=-Fv9WznGmAwHHBQJBa=1+_DEnZA@mail.gmail.com>
References: <CAH2r5mtBCP-sg6f3RH3RxO=-Fv9WznGmAwHHBQJBa=1+_DEnZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In handle_read_data() the encrypted/folioq branch
(buf_len <= data_offset, reached via receive_encrypted_read for
transform PDUs > CIFSMaxBufSize + MAX_HEADER_SIZE) copies the READ
payload using buffer_len rather than data_len:

	rdata->result = cifs_copy_folioq_to_iter(buffer, buffer_len,
						 cur_off,
						 &rdata->subreq.io_iter);
	...
	rdata->got_bytes = buffer_len;

buffer_len comes from the SMB3 transform header OriginalMessageSize
field (OriginalMessageSize - read_rsp_size); it represents the size
of the decrypted message after the SMB2 header.  data_len comes from
the SMB2 READ response DataLength field; it represents the actual
READ payload size and may be smaller than buffer_len when the
decrypted message contains padding or other trailing bytes after the
READ payload.  The existing check `data_len > buffer_len - pad_len`
only enforces an upper bound, so a server that emits
OriginalMessageSize larger than read_rsp_size + pad_len + data_len
passes the check and the kernel copies buffer_len bytes per response,
ignoring the server-asserted DataLength.

Two observable failures with a crafted server (DataLength=4,
buffer_len=20000):

  - the kernel returns 20000 bytes per sub-request to userspace and
    sets got_bytes = buffer_len, even though the response claimed
    only 4 bytes of payload;

  - on a partial netfs sub-request whose iterator is sized to
    data_len, the over-large copy_folio_to_iter() short-reads,
    cifs_copy_folioq_to_iter() returns -EIO via the n != len path,
    and the entire netfs read collapses to -EIO even though the
    leading sub-requests succeeded.

Use data_len for the copy length and for got_bytes so the kernel
honours the server-asserted READ payload size.  For well-formed
servers (where buffer_len == pad_len + data_len) the change is
behaviour-equivalent.

Signed-off-by: Jeremy Erazo <mendozayt13@gmail.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4825,7 +4825,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		}

 		/* Copy the data to the output I/O iterator. */
-		rdata->result = cifs_copy_folioq_to_iter(buffer, buffer_len,
+		rdata->result = cifs_copy_folioq_to_iter(buffer, data_len,
 							 cur_off, &rdata->subreq.io_iter);
 		if (rdata->result != 0) {
 			if (is_offloaded)
@@ -4834,5 +4834,5 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
-		rdata->got_bytes = buffer_len;
+		rdata->got_bytes = data_len;

