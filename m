Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FD137160;
	Tue,  9 Jan 2024 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KM3sSo58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70214C433F1;
	Tue,  9 Jan 2024 11:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704800463;
	bh=4aNVYkq/75x5lsWqp/Rnxx++cD+4B1lu9Dpu8b5mH5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KM3sSo58mWq1zh+cUHgm3H/wAVSH9GC8bUWFzrVIq5IPTR4zmbM8XPkTNjHW6Q/8v
	 FyxpY5nQJZEarLnbBJh4TLxQ4aBdhDnUImLac5j8K9irhoU7UbqGAojWL4GSKLa2KS
	 qdHMxI7DReat6uPnLqaDjZ0YDo4rMwh6LiNcnLWc=
Date: Tue, 9 Jan 2024 12:40:59 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@cjr.nz>, Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 6.1.y ] smb3: Replace smb2pdu 1-element arrays with
 flex-arrays
Message-ID: <2024010937-eggplant-bauble-d556@gregkh>
References: <CAKYAXd-aYvX9nOZ=gjruv5Mk0eS9ZdF569QBk2YCqEvR_nwxPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-aYvX9nOZ=gjruv5Mk0eS9ZdF569QBk2YCqEvR_nwxPQ@mail.gmail.com>

On Tue, Jan 09, 2024 at 04:18:39PM +0900, Namjae Jeon wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> commit eb3e28c1e89b4984308777231887e41aa8a0151f upstream.
> 
> The kernel is globally removing the ambiguous 0-length and 1-element
> arrays in favor of flexible arrays, so that we can gain both compile-time
> and run-time array bounds checking[1].
> 
> Replace the trailing 1-element array with a flexible array in the
> following structures:
> 
> 	struct smb2_err_rsp
> 	struct smb2_tree_connect_req
> 	struct smb2_negotiate_rsp
> 	struct smb2_sess_setup_req
> 	struct smb2_sess_setup_rsp
> 	struct smb2_read_req
> 	struct smb2_read_rsp
> 	struct smb2_write_req
> 	struct smb2_write_rsp
> 	struct smb2_query_directory_req
> 	struct smb2_query_directory_rsp
> 	struct smb2_set_info_req
> 	struct smb2_change_notify_rsp
> 	struct smb2_create_rsp
> 	struct smb2_query_info_req
> 	struct smb2_query_info_rsp
> 
> Replace the trailing 1-element array with a flexible array, but leave
> the existing structure padding:
> 
> 	struct smb2_file_all_info
> 	struct smb2_lock_req
> 
> Adjust all related size calculations to match the changes to sizeof().
> 
> No machine code output or .data section differences are produced after
> these changes.
> 
> [1] For lots of details, see both:
>     https://docs.kernel.org/process/deprecated.html#zero-length-and-one-element-arrays
>     https://people.kernel.org/kees/bounded-flexible-arrays-in-c
> 
> Cc: Steve French <sfrench@samba.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Ronnie Sahlberg <lsahlber@redhat.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>

Thanks for the updated patch, good catch on my mistake in backporting
this.  Now queued up.

greg k-h
