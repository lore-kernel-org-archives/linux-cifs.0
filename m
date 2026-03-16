Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD52C3B5829;
	Mon, 16 Mar 2026 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676386; cv=none; b=O6vaYI5XmQ0d41leND9qHEA0QePIK21SnqnvskJ3pbqa0C5TczeiTqniTjEALxR/c2iqn5Dk4FyQf9V5UeYksF18b+k4AZnaChaBfrZBxrIV/ObdjtpAVbCV9CqylTqnJ4R7gvG+3yzZzJ7d8b4uWQ1OYBbJXs6NCgxKDlMlglw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676386; c=relaxed/simple;
	bh=GVPXTbWdRY/AqUWudZIGMLuDdLgEC+jc83jt5BrEZ/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uK/I5h2Lf+SazAiPAh1+aVxFoCTWTBU2F1QvKSh9g+fhcDyG/uid9kMQt2Qcle/QkerPr72WANValFmHtXLZFZQtM1CtitXnzwdMh0kM1nta0K8qcSoPbjWNlUHGFaApxCz1zO3VTOQgeYZZtyIxG/kIKYK2GGu0/kP9lIyABXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hW4LYRTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hW4LYRTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D139AC19425;
	Mon, 16 Mar 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773676386;
	bh=GVPXTbWdRY/AqUWudZIGMLuDdLgEC+jc83jt5BrEZ/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hW4LYRTlYych4X6Sx5u6aXVoTkLivB/gDkqF3kcfZclNKKHUM3Kr2VW3baqJEdr7J
	 tK4oxHYsPmsrjiS43T2DkYtbzKDRwNa65E9qWorhVVuIrrM8hzBf69/OmdtzeqqL/F
	 dwq5c+E7AftGh2tU2C+mArZJywBvS1tcN9DJPtG8=
Date: Mon, 16 Mar 2026 16:53:02 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: stable@vger.kernel.org, linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>, thorsten.blum@linux.dev,
	pc@manguebit.org
Subject: Re: stable: [PATCH] smb: client: Don't log plaintext credentials in
 cifs_set_cifscreds
Message-ID: <2026031616-flashily-strung-a688@gregkh>
References: <eijo3pknvy4gl2xh23by7kjdxpoc27an3dqfmfttremp4xb53o@z2kq34l2onvy>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eijo3pknvy4gl2xh23by7kjdxpoc27an3dqfmfttremp4xb53o@z2kq34l2onvy>

On Mon, Mar 16, 2026 at 12:49:00PM -0300, Henrique Carvalho wrote:
> Hi,
> 
> I believe the following commit may have been missed for the relevant
> stable branches.
> 
> 2f37dc436d4e ("smb: client: Don't log plaintext credentials in cifs_set_cifscreds")
> 
> Could you please consider backporting it?

I see it in the following released stable kernels:
	6.12.77
	6.18.17
	6.19.7
	7.0-rc2

And it is in the 6.1 and 6.6 queues for the next stable release for
them.

Do you not see the same?

thanks,

greg k-h
