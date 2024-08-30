Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E420EB;
	Fri, 30 Aug 2024 00:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724977392; cv=none; b=q1EJa1eUFRhRGgzjz7LMpqzIB5b88MDGuSPqPCSt2rAD+oItXx2SeJ6IcmBGdX6NtwpASOL64OSL5mF7tGpebMcmPeL1uMad3IwIPHrsxFEHk++mchHRQNjSwhWE5tUoZxa0Nn9TNfMr1mI3WofJuf/fY7T+MSa/XiFGxxNIZZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724977392; c=relaxed/simple;
	bh=lh7JLnFP5s1aJ5xS8eg+yLx07MrFuSLffVxCf49ZDdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2i/wOwPdfUjiFPTbcfOlS1LTqNV0RnOlkYNJjGEohyhXqSPWVlMwgei7LRA4P7eK7a54+dfeKupYF3ieGWWw+YbpwyvmeTeA3p3pwfcoUT9mXYv+oQpMh0B+z9uzmi6Lig2R9wOJSW2T32CS2tMbop1H4Hv8299zyX/Fs+SA2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgUuwC0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgUuwC0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE0C4CEC5;
	Fri, 30 Aug 2024 00:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724977391;
	bh=lh7JLnFP5s1aJ5xS8eg+yLx07MrFuSLffVxCf49ZDdA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UgUuwC0F/jwl0XlnE+41/CzyQeeMhrt8Bl0bZHck3USg+o4ZKZYON1GfHiuxOkGki
	 qEicXvp9dujgeif7ji02FsPdClxBTWMqfMGHqJq8h4i/ytwr8wanzqEmW3uLSxGeq5
	 OJz5hrFmQ4GV+H9zxVixMpPwCne4wDt9wZ+sTsxvIKRbDCWcC7YUVo+gYxTO5lJ0SQ
	 mRT271mx5zP5Y75pRIZ1pjeQDSJWTO0lFI0jXalC6FM0MQvrkn9xW2hjHeKTVnOhd2
	 6i+uTUnp06Hr2cywFhl6p+xqLLUaSBV/p3+T5vcKD9sPEzyeTkRkvdX1XcmqEO8EFg
	 UTX39C3pY4YTQ==
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-70f670eb827so189606a34.0;
        Thu, 29 Aug 2024 17:23:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUBjj+TG7kpmHOtSxszaLpFIXbi14CX+Kzr2GFQuTGiBctYVVSflZt+Kab86C5ZTxG3GL4W8GxPIOVTAkKV1Gk=@vger.kernel.org, AJvYcCUU3v4i7IDRe0QsZ9DOqjhhHSobjzL9858KLQ6XzBV673ubONaBTkCMavvDVIzhJchAkB7p2yxJgCmSpuDW@vger.kernel.org, AJvYcCXWK0IlLsWJoQMOK/8RtiE3U6IiKazNzXWLHMlfv+Q1+asiENEIR4daHN60KV4ys3aihTumuMRFOnJxxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyK7X67KsQSIAplBfVTnOdALFBH5Jmww9xsFk7DFHDZAVbo69vd
	Q3kcWbmErCrbqR3ZJ+b4omOGp9iR1zuK5rIuIH27W2O70hGvw4+YaBSVYrc9CLvhsvGujQOLdjW
	0WsSUVebwn2CnPnU+SzjF1ulMmS0=
X-Google-Smtp-Source: AGHT+IF1HOIvuR07ISWkm9lOBPvOjH1Fv+cPfeKw7L2knPjRe2Cbni0rIZvQV07RTjTSNXDkJ41oZxVbgwUNcvuSAdo=
X-Received: by 2002:a05:6830:278a:b0:703:6b11:33a4 with SMTP id
 46e09a7af769-70f5da97fd4mr1154441a34.9.1724977390911; Thu, 29 Aug 2024
 17:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <89c440a9-27bd-45d9-9d5b-5b4bf51ec950@stanley.mountain>
In-Reply-To: <89c440a9-27bd-45d9-9d5b-5b4bf51ec950@stanley.mountain>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 30 Aug 2024 09:23:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Wdb+Ss1GODQBh8Mxrrx=dWWD1zSiR6JCeMYQyR5h0Fw@mail.gmail.com>
Message-ID: <CAKYAXd_Wdb+Ss1GODQBh8Mxrrx=dWWD1zSiR6JCeMYQyR5h0Fw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Unlock on in ksmbd_tcp_set_interfaces()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, Steve French <sfrench@samba.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024 at 4:22=E2=80=AFAM Dan Carpenter <dan.carpenter@linaro=
.org> wrote:
>
> Unlock before returning an error code if this allocation fails.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Looks good to me.
Applied it to #ksmbd-for-next-next.
Thanks!
