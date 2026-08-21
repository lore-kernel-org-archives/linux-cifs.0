Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B76480348
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 11:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787310167; cv=none; b=rzqwDUnOgw0FjDsc1Uj7hoz7t3a1DXkXxFE13Qi6ALCknZs5KoXF4SC0JT8EiznZ85L9eIhQ05vRFAhkn/6fi3/i6VyifcFw8yJi74IjpThmp11MOzxFheGRMS8ogcTQ4zLUn9QyIfoRoGsm/Mw/++jpB6NFnnxAg6cKWL22fuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787310167; c=relaxed/simple;
	bh=E6/B7FL0zi3araSBiTSbz62qcwkieMdNtUo8MRpBt/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lQcSHmqoYWHsbSLW2FHG5/NMZx3UrnEXhVet3MfuaCIJHdMTPIDSta//1aqclCTEGrdqVunSoBejLzSnvP6YtwG0vnfd/5aceP/2xb3zbgbNVzI/g/Z5ZTlzXHhKlk4kfod9F/bclqQrnT7AAghITSOCu3t/LLbtUbSgYqAMBAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGDts2ed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGDts2ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685C91F0155C
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 11:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787310165;
	bh=hvEejkL8RvMzR7A62NfyXUaxeFgOTDxP9QfX7tV3HFs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lGDts2ed9MjUHNlGIx130NNg9Bsb0b+tJy4pfOo6/YmSTK18vixLpuc/aQPopcw4+
	 0yyAmmt2gOP04c8OmTMobwtkqEoDgd5sJTKC3oihJRwKKQXw7ZMUK9CKv20Tmc0XyP
	 pUTRYFvkgxn78PYLXi+/9mgne+zDB0yg72ZWKEnrrPidDB3tshomZxhoLfswra3p71
	 3oPBmTMTgoPjwtIwW06PiJZQXi7E3v61jTJ5Iu21/clexoUGURtfRbiAANcWwJhX1a
	 V/iWMQ1pCcrM7nmE5nrkBP0vyJp5UQXtjh1C1OuPks41wyIJ2OtoQBUo1tvG2Eh4lM
	 jIupCe+1qohQA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c214321dc32so169623166b.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 04:02:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpZNwc4zX5vH2wD26Frai1U/DgoJcN1BWEP6HmxXZH/WJHcl0uLhqKzlt1zSyf4ZtjmcbzYdEwfBy1P@vger.kernel.org
X-Gm-Message-State: AFuF++lRH6rkiS6rxN2aozfU4l+H2HCdGRc1AmMpXvJeTskS0fsSYDJT
	3JSHEjfiewrBEd/CIq67p6NJVvuGR7Pt4ePtj97xHkQwlkVmvCuA7US77kY+GYY2cXE0nAwrUsQ
	bq4zYCaN1y8o4p40/tCAHlXPtuk0NDT4=
X-Received: by 2002:a17:907:98d:b0:c12:b2db:873d with SMTP id
 a640c23a62f3a-c246a2ec634mr658427266b.5.1787310163800; Fri, 21 Aug 2026
 04:02:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@proton.me> <20260820-b4-disp-58f78a28-v2-1-1fb7a6cb1533@proton.me>
In-Reply-To: <20260820-b4-disp-58f78a28-v2-1-1fb7a6cb1533@proton.me>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 21 Aug 2026 20:02:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_L597uCWw3VF-pGoiYAhuAEN5hfVgX0OEdyK+yZpKRgw@mail.gmail.com>
X-Gm-Features: AcwNN1W2YXGitLnbU9HdeaZZB7fbkZ2JxO0HGUfWc8Qy18x9g7dpa04IBiEUxgY
Message-ID: <CAKYAXd_L597uCWw3VF-pGoiYAhuAEN5hfVgX0OEdyK+yZpKRgw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: let enum smb_eio_trace grow past 128 entries
To: hexlabsecurity@proton.me
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Shyam Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	David Howells <dhowells@redhat.com>, Nathan Chancellor <nathan@kernel.org>, Tom Talpey <tom@talpey.com>, 
	llvm@lists.linux.dev, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
	Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 11:25=E2=80=AFAM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> enum smb_eio_trace is __mode(byte) and the list has held exactly 128
> entries since it was added, so the last sits at index 127 and a 129th has
> no representable value.  clang gives the enum a signed underlying type an=
d
> converts the overflowing value to -128; x86_64 defconfig turns that into =
a
> build failure because it sets CONFIG_WERROR=3Dy, and where it does not, t=
he
> value stops matching the __print_symbolic() table and those events print =
a
> raw number.  gcc picks an unsigned underlying type and reports nothing.
>
> Drop the attribute.  On x86_64 the record does not grow: the field
> precedes an unsigned long at offset 8 of struct trace_event_raw_smb3_eio,
> so sizeof() stays 32 either way.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202607290344.fvDmgRPA-lkp@i=
ntel.com/
> Fixes: f80ac7eda1cf ("cifs: Add a tracepoint to log EIO errors")
> Cc: stable@kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  fs/smb/client/trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 5b21ad3c15fb..0a91d3aaa079 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -213,7 +213,7 @@
>  #define EM(a, b) a,
>  #define E_(a, b) a
>
> -enum smb_eio_trace             { smb_eio_traces } __mode(byte);
> +enum smb_eio_trace             { smb_eio_traces };
Looks ok. But these patches should be squashed because 0001 patch is
only required to make the new enum added by 0002 patch build
correctly.
Thanks.
