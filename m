Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D853C39
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433350; cv=none; b=IleDd1SEFWBGIKIQVV7RsjQj2mA0KHUWgTs6snXW43uitoNcvQtMy3rFZyh15Z+0/qXWXG8mJIk8U0WW0BHfqxSdQCj/586fxN7rC1fG88nZx/2NzdsbFb6yOeLmM4OkaUnDFuvRrl83K7J8IyRaFB08d1baoN0LgIFXG64zmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433350; c=relaxed/simple;
	bh=gkeg5FfpWZqaVyG9/EhLK39KNgmullsimyuX4NDwF84=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RGWR9Z/hFEqGwMq2VMN0usyMQfS+wJwP3hGRr43BRY+fHhjg9aeZp4bNpAgRJpGl42VT/l/JcBRfxfj3l8FBb/ioIgDPi61cIDfwLd20RWf0ZLWkkTSmIjhNYSgLFqJvymX882EMrXdEAyWac8fCDyVw+noeMHJLU6g/wT2ZmFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iIrMy6ZL; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iIrMy6ZL"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-704466b19c4so1118030a34.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 16:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721433349; x=1722038149; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9umqlUuv+T6TowTfKLMy0nnlmMay139uhGM2AAYpfxk=;
        b=iIrMy6ZLhK38UTMxhnTZ0aMr39U/XBTDDupimTjKIzbmyeDfn4AoZbOWvT6UnrVVp8
         8Z9wu//UhI6pomaMOONCp4IHhAuO7BlaKAdZdrTAwXYhuMaz1Q9bCA1rEB1WnlOxaDsf
         kKcKIgN4uYzF+vMLjYV9IFdQlvgZUzrYjId1p4dA6+AGTmVIGoCotBUM3hV1sYv5360O
         vft0VKjdVMktHpN+eAKwwjUQHhA7jb5/iO0ACh5gt9jxiTNh/5R1loaHmCoYKJSh005f
         b/ymE4KGhD1h+A1FvxbZ4pBaHe6iPWQDC0VAYlu9UIcUHax7+hXVEW4Y4ax/X1bL9K6g
         tUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433349; x=1722038149;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9umqlUuv+T6TowTfKLMy0nnlmMay139uhGM2AAYpfxk=;
        b=feM+uJPrgH2FPolENDvq5vRNg/DUrpOZKih+kpgRa3J2K6hxw/e/O8hV/3Tf3cqvdS
         L3XO4H7/+oaysU2GDRWP93u+d2uIsMPSUS/cbeq5yhwZj+SIQWYm9boBl72lc3n6XKx4
         R8AI3G49v2A3ix9onM6pNZmSWR4ht8i45XrO9ZBx+8rWYuj64hJ4xqr/pQZLxw0SHrz/
         f1OP97ok7xyRtPJcrZzB+fTQWrz53HJXOV1fBY77jGc1ewlWkF25mQSe5Qcg+ssozEB+
         FmwkZUCQKtK3kjyLdX3Fg4JzeZETQJ/sQfyoGfAXHcCkIdFQPtQakIjvibnZuhI6cr+C
         hSoQ==
X-Gm-Message-State: AOJu0YxAbVXIVEFcUpKZv1F5vdYUjB5gx/d+ED4WCgE1iK/q+W9Ivm0Y
	RNgYHJffibz85/SDL0gVJNJ6gO07NLVTxL0AeVowD5euHb7WERurZvAs48pfqN4=
X-Google-Smtp-Source: AGHT+IEWiJ4c14UGSmveJ1rWwpY14HHxf/kSO7IvYvqZzqX9yMk0fbO9zzDY8wHnfeI37NsdaCM79g==
X-Received: by 2002:a05:6830:660d:b0:708:b419:d28f with SMTP id 46e09a7af769-708fdbb8f62mr1696581a34.30.1721433348757;
        Fri, 19 Jul 2024 16:55:48 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:739a:b665:7f57:d340])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60bf2e8sm518884a34.19.2024.07.19.16.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 16:55:47 -0700 (PDT)
Date: Fri, 19 Jul 2024 18:55:45 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: add server-side procedures for SMB3
Message-ID: <e82b0892-69aa-4a14-b917-443fce9be3d0@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Namjae Jeon,

Commit e2f34481b24d ("cifsd: add server-side procedures for SMB3")
from Mar 16, 2021 (linux-next), leads to the following Smatch static
checker warning:

	fs/smb/server/smb2pdu.c:8864 smb3_preauth_hash_rsp()
	error: we previously assumed 'conn->preauth_info' could be null (see line 8844)

fs/smb/server/smb2pdu.c
    8832 void smb3_preauth_hash_rsp(struct ksmbd_work *work)
    8833 {
    8834         struct ksmbd_conn *conn = work->conn;
    8835         struct ksmbd_session *sess = work->sess;
    8836         struct smb2_hdr *req, *rsp;
    8837 
    8838         if (conn->dialect != SMB311_PROT_ID)
    8839                 return;
    8840 
    8841         WORK_BUFFERS(work, req, rsp);
    8842 
    8843         if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
    8844             conn->preauth_info)
                     ^^^^^^^^^^^^^^^^^^
This checks for NULL for ksmbd_gen_preauth_integrity_hash().

    8845                 ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
    8846                                                  conn->preauth_info->Preauth_HashValue);
    8847 
    8848         if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
    8849                 __u8 *hash_value;
    8850 
    8851                 if (conn->binding) {
    8852                         struct preauth_session *preauth_sess;
    8853 
    8854                         preauth_sess = ksmbd_preauth_session_lookup(conn, sess->id);
    8855                         if (!preauth_sess)
    8856                                 return;
    8857                         hash_value = preauth_sess->Preauth_HashValue;
    8858                 } else {
    8859                         hash_value = sess->Preauth_HashValue;
    8860                         if (!hash_value)
    8861                                 return;
    8862                 }
    8863                 ksmbd_gen_preauth_integrity_hash(conn, work->response_buf,
                                                          ^^^^
This call doesn't.

--> 8864                                                  hash_value);
    8865         }
    8866 }

regards,
dan carpenter
