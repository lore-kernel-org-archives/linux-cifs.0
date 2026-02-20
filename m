Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932511E5B7A
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 01:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771550876; cv=none; b=iYogBEmY0fm2+x+IOm8hAVh4m8Oyf8gu3/T8SdzKvO81bS2Jm9YrUrEV+XZr+9SLwktBG6z0utEDouaEE+GBelA39sbYE3Onsmedxq126OyyazVjFgAVGKDP49FZXq1Yps6RtrrL5HuOKDnk/1K1kEBxqtgzL4QI/xJblVGhZuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771550876; c=relaxed/simple;
	bh=7x6pwxHgNz90VxndZvGZsO7PWpxnTBvaHwnHtuHLFNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tTMgmeAnk4ogyuOTIpOz1nSuEx5a8JtrR6jt4DUYsWYl9+k/4cEXYdZqoTu2WzyhsUURAzLkgKcLI5+D7i9A1iQ3RdbNQg8AE6DhrOpodg+R4R2cEJtRWLAmvF0qznaB9RpxbHsXRwxsyBrfjrfIn5SZECZVL7og5OSk/M9DMLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0fPrk6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0fPrk6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C86C2BC86
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 01:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771550876;
	bh=7x6pwxHgNz90VxndZvGZsO7PWpxnTBvaHwnHtuHLFNA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=q0fPrk6dYf8c4hrxnoLsiaW/a2DYwjGBnGrNzKSeaVXMA6rN0cOzAS7DF7BCxNp1U
	 H594hmBdggdTYRLsTkWysjf7y3ARG3HIFrl7RjxjEL0MiOYskvfEv8eE9v/EMfaF5r
	 JAKAVgts6vCdUITiNcc2j0ntf2rNOICQzHoAX+ZzHM351ZYZRg5sZRzfDJLV8RCcg2
	 +x++x/dVGqDPdpbl6aniw2o6Uy0vAipWU6Kcap4KkJT4+BNlHZDQuW1bQqNAGgqVv8
	 a4tqMTeemW3Oz6OLpuwBkW+gIkjcl2D+/eiMVaW3Lfd8JO5p3jVkFnFlLpuaxE76W2
	 g/KzAvYMg3Qaw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8871718b00so254624866b.3
        for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 17:27:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWQ25wCuO6rKDSlR8Ag90hwS1cqylkrv6MqtSXo6Ldn8JgXHdV5grPyAgw3lVvw4Wx3liZewRU9OYp1@vger.kernel.org
X-Gm-Message-State: AOJu0YzxaTpiwqdh8UAfNw2z/lvfh4jBvhCDcADIquEYs62V246kRKha
	7BvGFKJcBSOHJ6MdBaQG5MfShPD9sIvRpi7NvgdeTpiuu5nSZdpPxuRxHEI7oKOSSy+HVFbjZJR
	T5cKl8S/KGikwCzK4CmrS/kmfIIwx6YA=
X-Received: by 2002:a17:907:3fa1:b0:b87:4c37:7fd8 with SMTP id
 a640c23a62f3a-b8fc3ca9c56mr1063970866b.49.1771550874452; Thu, 19 Feb 2026
 17:27:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
In-Reply-To: <20260216082018.156695-1-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 20 Feb 2026 10:27:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
X-Gm-Features: AaiRm527LbKUmit9y_r2hXZWlcXKaMp394FEozMONoaXuigBUWbKpiEhMrTY0wk
Message-ID: <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: zhang.guodong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn, 
	chenxiaosong.chenxiaosong@linux.dev, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> ZhangGuoDong (5):
>   smb: move smb3_fs_vol_info into common/fscc.h
>   smb: move some definitions from common/smb2pdu.h into common/fscc.h
>   smb: move file_basic_info into common/fscc.h
>   smb: introduce struct create_posix_ctxt_rsp
>   smb: introduce struct file_posix_info
For patches 0004 and 0005, please move the complete definition to the
common header instead of a partial split. So we should also use a
flexible array member for this, and ensure that all related code is
updated to handle the flexible array correctly.
Thanks.
