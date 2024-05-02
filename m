Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7D613C811;
	Thu,  2 May 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714659224; cv=none; b=ivQ6qguK1bhqtIgGBw+oUl49SRtCgweDHUdLm1tCtkkwoX+USkW1rdz1cOYWsskJ7obh2SNMCgzSCc3iTPRydcmx/ydTVg0Con7jwGLs8xo1qbKv3lDyJG5PAw/hmI2l32sWBdUSPMnJnm/LIY3lXC8jsfnSpARXWWXgxvJ8DXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714659224; c=relaxed/simple;
	bh=1vUXQjL1XIYEiLePPiS1dnxjykzdCGKwKFECXqOOXzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dfijr899So2gKGZhhOFuuXhuDaT+9Je6XSmudKlLU66jl6Sp+qoS5kVTO0d8gW1rO1WI9HoMBflVrvuFg57GuiH32442hiceyjYne54KMNv7L4WJSooLPHoUZynmg0bXsDEx6DhOoz7toUOOVNtYQ6ASMoV5ULoGIDUyvi4fDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l8xTyZlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l8xTyZlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC64C113CC;
	Thu,  2 May 2024 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714659224;
	bh=1vUXQjL1XIYEiLePPiS1dnxjykzdCGKwKFECXqOOXzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l8xTyZlQzl3HNe7cUjrdAgZ1NKd380t0HFvkjEvsnV+7K5cONejVCpBir2khe4grt
	 IHE37n0odjwFWjz/dLJui5uXE5zfT9y8I1oyfmFlDdHY7oyIsrTw7Xb15EJyap380V
	 GMJManJexVkv5kFR40UDgRIsUVtRd40xVghp5dqGaG6CIYeXa1xt7Qzaj4zUSQ8FhV
	 JsgIQvMoLGc7x+BnQLcd8FPPXmn1PO4F7pMQnOljy2mhEAxQbdQLzvXyu1JGonVQwJ
	 8dTasmNqJ5lcRe9QZ9Ua3V/Ay4cBLszk1nRUPXCRxvO96/f+LYcCnJs0tbTM9EYqQR
	 2zqWufBT8RCPw==
Date: Thu, 2 May 2024 16:13:38 +0200
From: Christian Brauner <brauner@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, 
	Steve French <smfrench@gmail.com>, Jeff Layton <jlayton@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Paulo Alcantara <pc@manguebit.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, netfs@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/16] netfs, cifs: Delegate high-level I/O to netfslib
Message-ID: <20240502-beteuern-vollzeit-54b8237c2809@brauner>
References: <20240430140930.262762-1-dhowells@redhat.com>
 <264960.1714488463@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <264960.1714488463@warthog.procyon.org.uk>

On Tue, Apr 30, 2024 at 03:47:43PM +0100, David Howells wrote:
> Hi Christian,
> 
> With Steve's agreement, could you pick this set of patches up also?

Pulled both branches from you. Thank you!
