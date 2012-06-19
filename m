From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 01/22] CIFS: Add SMB2 status codes
Date: Tue, 19 Jun 2012 15:22:07 -0700
Message-ID: <20120619152207.6d48ec92@corrin.poochiereds.net>
References: <1340109611-7210-1-git-send-email-pshilovsky@samba.org>
	<1340109611-7210-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340109611-7210-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 19 Jun 2012 16:39:50 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> +#define STATUS_GUARD_PAGE_VIOLATION	 0x80000001
> +#define STATUS_DATATYPE_MISALIGNMENT	 0x80000002
> +#define STATUS_BREAKPOINT	 0x80000003
> +#define STATUS_SINGLE_STEP	 0x80000004
> +/* #define STATUS_BUFFER_OVERFLOW	 0x80000005 */
> +#define STATUS_NO_MORE_FILES	 0x80000006
> +#define STATUS_WAKE_SYSTEM_DEBUGGER	 0x80000007
> +#define STATUS_HANDLES_CLOSED	 0x8000000A
> +#define STATUS_NO_INHERITANCE	 0x8000000B
> +#define STATUS_GUID_SUBSTITUTION_MADE	 0x8000000C

Well, on the plus side, you did comment out STATUS_BUFFER_OVERFLOW
which was a definite conflict with the definitions in the SMB1 status
code list. However...I'm fairly certain that there are other conflicts
here, so that was just an example.

You really have two choices here:

1) make smb2status.h and nterr.h be mutually exclusive. Ensure that you
never #include both files. At first glance, this may be easy, but the
trick will be to ensure that no one does this in the future.

2) rename all of these error codes such that they do not conflict with
the SMB1 errors. This is more certain to ensure that you don't have
problems, but it's a bigger change.

I really don't care which one you choose, but we really do need to take
steps to ensure that we do not get conflicts here.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
