Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A31ADC9C
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 10:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736849905; cv=none; b=Y9hfhgLIbsgkjhX3QkY2JiHm7+gwFPvexeQt4zaPRv5FjsmzbMPLR5xKN5mLnNC3wc0EowZJ7PvGEQ1xyrNFvDeuV6GhjWGi0c6ZQ6+/c2m+ppXUJ1b58MfAWNL10YhjdfBEM3/hayubOAvx4lNg7SfMcU0Af5u7Q0xoz4z4MqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736849905; c=relaxed/simple;
	bh=Phk8b9T+9WHb4sdBu4TnvawdtCyfivT+01BinaHctZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwrZMEeZPKaNxnFVACVDxnTy/f+XS5+glUABLh9S8l9+ClF9WOmwSulA/55+eO8D+HmYTTpSj+l4JrT0CvB9V4nXPPLgr0yViGQp68dHa+cYPKJyO44c+3wiYM+6FWed0LbSLcJD7++zs0omJG2zHqnTxy01CFwDfN17YV+J2Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xurKFT/I; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xurKFT/I"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab2e308a99bso156868566b.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 02:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736849901; x=1737454701; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HiN+MGob9C/wk/ZA5GyHyYf/yvpWUeM+njdEkAZ9s5M=;
        b=xurKFT/IORv/Svwo/aRFaFpJxYIS0HAy715idWlpOTpFkXLA3LcZnaLZrP2yHkL34d
         lPGZdyagE/svPtk0ohFx7/Ts0LKDURKWPhgf9D8xqICaQLZspizYOoUSjvVHkP+fMt9m
         okntnJDC/KxxKUrzypOgedKoU85c+LsV+v/DDBow0M0wjC6HKiHdGdWlCqWXDiZ/G42Z
         2MUnFVSWllXAiM9tLtqrRBlOuT+LKDU6XXMs5P7DdE/jkTETsld8fcrtPBSgdNlsQnVP
         XMbhD7BYzxRizW/LNuhdZk0WPRigmgTrAOxd/AvEx5EX8tc7UQ8ETHPJ4HTx9Eqc0IU/
         w4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736849901; x=1737454701;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HiN+MGob9C/wk/ZA5GyHyYf/yvpWUeM+njdEkAZ9s5M=;
        b=khRvOiWTsXghFDmtCX/i3ezyeYL3eTE12mCY1UHlDxdGZ6N7LBiASz0rW+I0+Oe/nt
         Sw2LPOJnVWkBLlS/FMR4CFsO5HPwmdH7PrDnV1uLAvnbqiXHynyOlT0ioCC9vZKqTeAu
         +LwLZ4DYXokDWt8cmpeZb5kE7CfgDMRRwW0V+JSzhK+Nw4SEO5KZjW72Q7DXI11gwxRQ
         fPsn0CK+QHlIE54lZY1wnCrO7sahCWFga1jXwFwlfRtcYJ0TEJKUroJrNIvffqb+aOiy
         wfnlXUquJTHSC2Mx2jSjs+bC2Sodl3+StPAH+ysgpsJpZaatelVraHbMsLyASVwjNJgs
         7GeA==
X-Forwarded-Encrypted: i=1; AJvYcCWpQwzZi9H9aBSuItK5h4lbwIOZGVs8q4WcH8Bmas9fpe9ZN7aMpI+9ZeNd3u47IZqnRtmJoX4RUY7a@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/12dscFuW2URGI4Lz/BtiqBRFVt1qMOGvbYuG8aRkmvr+AHaV
	6I7knnyzp6qMX/MeIfafr6c/tbvTl9Iw6CoVAmPb+j6HOgq9pbVhfFDStU7xi3M=
X-Gm-Gg: ASbGnctRL9c3mjpBWayGxkz6I2W388f1VCSqISxGkUBeErqMKTvObbOJclTCrIPol3z
	IRopN9fVgkz8U69ywzwCa41mGDDoUtgLtPqOvicAm/HNLTXMEnLekACsavo/Dx39ib+lL8Y5eF1
	nreiZAQ3w4hLZhkbPLPiJLJkf+S+i/4WcXBU0n+Nao143WODJYs3M1hSTmuYyDZwDHFLa5LATAO
	72Treqrt8Ajlj38ZTNNXIovIfciwu7/YzoOnuo20T32DvZduH/JyLBhKE8MVA==
X-Google-Smtp-Source: AGHT+IG7WJ9asuOTLZHhddJPlsSkJ0crkaJ1q1rMz0GpfqaRWdDxghBy3ePeVf/MPb7/xuRHzAReRg==
X-Received: by 2002:a17:907:2d86:b0:ab3:42b2:2886 with SMTP id a640c23a62f3a-ab342b228f4mr34692266b.3.1736849901536;
        Tue, 14 Jan 2025 02:18:21 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905cd8asm609773166b.7.2025.01.14.02.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 02:18:21 -0800 (PST)
Date: Tue, 14 Jan 2025 13:18:17 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH RESEND] ksmbd: fix integer overflows on 32 bit systems
Message-ID: <2fb3efb4-a889-4b49-8100-51147d9ae426@stanley.mountain>
References: <b00cd043-7e52-4462-8bb7-b067095bd5fd@stanley.mountain>
 <CAKYAXd95gAZ4h1TJtFg2bKakSLQcR2294+mZ1tJY5zb2V-rhaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd95gAZ4h1TJtFg2bKakSLQcR2294+mZ1tJY5zb2V-rhaA@mail.gmail.com>

On Tue, Jan 14, 2025 at 04:53:18PM +0900, Namjae Jeon wrote:
> On Mon, Jan 13, 2025 at 3:17 PM Dan Carpenter <dan.carpenter@linaro.org> wrote:
> >
> > On 32bit systems the addition operations in ipc_msg_alloc() can
> > potentially overflow leading to memory corruption.  Fix this using
> > size_add() which will ensure that the invalid allocations do not succeed.
> You previously said that memcpy overrun does not occur due to memory
> allocation failure with SIZE_MAX.
>
> Would it be better to handle integer overflows as an error before
> memory allocation?

I mean we could do something like the below patch but I'd prefer to fix
it this way.

> And static checkers don't detect memcpy overrun by considering memory
> allocation failure?

How the struct_size()/array_size() kernel hardenning works is that if
you pass in a too large value instead of wrapping to a small value, the
math results in SIZE_MAX so the allocation will fail.  We already handle
allocation failures correctly so it's fine.

The problem in this code is that on 32 bit systems if you chose a "sz"
value which is (unsigned int)-4 then the kvzalloc() allocation will
succeed but the buffer will be 4 bytes smaller than intended and the
"msg->sz = sz;" assignment will corrupt memory.

Anyway, here is how the patch could look like with bounds checking instead
of size_add().  We could fancy it up a bit, but I don't like fancy math.

regards,
dan carpenter

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index befaf42b84cc..e1e3bfff163c 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -626,6 +626,9 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len)
 	struct ksmbd_spnego_authen_request *req;
 	struct ksmbd_spnego_authen_response *resp;
 
+	if (blob_len > INT_MAX)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_spnego_authen_request) +
 			blob_len + 1);
 	if (!msg)
@@ -805,6 +808,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_write(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > INT_MAX)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -853,6 +859,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct ksmbd_session *sess, int handle
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > INT_MAX)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
@@ -878,6 +887,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_rap(struct ksmbd_session *sess, void *payloa
 	struct ksmbd_rpc_command *req;
 	struct ksmbd_rpc_command *resp;
 
+	if (payload_sz > INT_MAX)
+		return NULL;
+
 	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
 	if (!msg)
 		return NULL;
