Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A38520322
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760938079; cv=none; b=b1HZpUkOvjyUXBoA7RTTVhDXl500wWgnI6LZCClEiNbYUHYBjuqEBqzulL3LI/Mv1vbcAzIKtIf5ENy+9EyVrXWrMKiNZ89bKg74X2LaaW8wwYhAhqfXwv5HAzpQl64b8O9eAJEshbEEdnpK/olodSaPoC8ySF8u7jHuOuVr8ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760938079; c=relaxed/simple;
	bh=Rhn9RghkieVXavXFsw1GsXB7Wh30HKSirJ/CqjGLVv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fSImaEG1h4494NUAXk6lqbPEsSHXF74DNqxl1gktuoVQh++dUM0T+sSBxHfXprC41HRd8ZvhxvTc06GdzHAOR5mT2ID0/4pUfDS82+epwJEL4rJZr60KlYI6ekggBmNDhW2Ah3Z05GdO54J/jdsr6dy5swAKKGgElQwaR1YfYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3Y2SFUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3Y2SFUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1607AC19424
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760938079;
	bh=Rhn9RghkieVXavXFsw1GsXB7Wh30HKSirJ/CqjGLVv0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W3Y2SFUAPU1uUXMpqvgjmjDjf+X84hFEBcmph3q+8UORmzhHPEGbtLhhiu6fhOeSe
	 aaN5hgod13lwD0qxCj0uKkpNWEvi1H7jvTWnfI39h3M8A8qDQDTM3FWUMiXuWGFXO2
	 xBl+pQS0oW/U5yPMCYeO2aFqVTy/PfiTbSB490v6KuEl1dLYtdoFoSnx2q5kr+oZRF
	 B1nAitW2kveeI/h6a8XOJEAWF7R8zuV9oSeWOwVhgDl0IsESzgc42wfH1c8luc6vBx
	 1UW3mhkSH6unECv7VF0l1eteln2vnZvauIRWDSsgvFeounYuVc/yRVr7Vyhb7NhyPp
	 F5dRAjbUgKiwA==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3b27b50090so705921766b.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 22:27:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWwOs8IvRu0/sMFfll0VxJmVfadM3O4w28MSEel74QRmzifNwQz8PaCl71hTn708Vwz1iwGp6yQugPk@vger.kernel.org
X-Gm-Message-State: AOJu0YzcTXrV214aZbb4azy9XlcuZkrDG5vzIHCqjE5D9Lhgx45Jddfh
	/e3zEWdBOu+Gj4TJlybfku7pIQd4FQvUS1wx2hlbrjo/BITJIyVuVYHxRq0cesJgLCxFaXiQMje
	Z0MQ66Q0fDVkXDaMZB6kcM0Sj8je8I+g=
X-Google-Smtp-Source: AGHT+IGDW8czczafGIaU7OlUDZoJ10eSHJSLiJbgJbPQ0Z9lUURiWzCSVuT51wY0q1gwGEdfKSk+jCY5jijB8Ci1WWE=
X-Received: by 2002:a17:907:948f:b0:b57:2b82:732b with SMTP id
 a640c23a62f3a-b6475706215mr1318772666b.54.1760938077614; Sun, 19 Oct 2025
 22:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev> <20251014072856.3004683-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014072856.3004683-3-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 14:27:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-4oA1JV7zjrdKqw835ErnOU9ge7RYfbL7ij9X-OAY9hQ@mail.gmail.com>
X-Gm-Features: AS18NWAZbXqncjmf40pzKp9y1UX8J5cRXebetK5uLUZuP3Mwxa3VxfKlcXcerNQ
Message-ID: <CAKYAXd-4oA1JV7zjrdKqw835ErnOU9ge7RYfbL7ij9X-OAY9hQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/22] smb: move file access permission bits
 definitions to common/cifspdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +
> +#define CLIENT_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SERVER_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define CLIENT_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> +                               | FILE_READ_EA | FILE_WRITE_EA \
> +                               | FILE_READ_ATTRIBUTES \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
> +#define SERVER_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
> +                               | FILE_WRITE_EA \
> +                               | FILE_DELETE_CHILD \
> +                               | FILE_WRITE_ATTRIBUTES \
> +                               | DELETE | READ_CONTROL | WRITE_DAC \
> +                               | WRITE_OWNER | SYNCHRONIZE)
What's the reason for moving it if the smb client and server don't share it?
