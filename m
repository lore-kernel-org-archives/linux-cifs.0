From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix length checks in checkSMB
Date: Thu, 27 Jan 2011 17:02:25 -0500
Message-ID: <20110127170225.03274b03@tlielax.poochiereds.net>
References: <1296132305-21872-1-git-send-email-jlayton@redhat.com>
	<AANLkTi=2A5VUOz7aTCm_EbeRZdD=e7tq=sd3AAPbzTiR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=2A5VUOz7aTCm_EbeRZdD=e7tq=sd3AAPbzTiR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Jan 2011 14:41:14 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> If a server has a bug and sends an SMB which is more than just "round up" off
> in length - I can imagine a case for making exceptions depending on the
> details of the type of malformed frame, but since we
> already allow 512 bytes (for "incorrect server rounding of frame size" bugs)
> we should be careful.  If the length is more than 512 bytes off - this is
> a server bug and the probability that the rest of the frame is incorrect
> is very high.  How off is the frame you want to allow.
> 
> No objection to fixing the error message - not clear on the other part.
> Generally my intuition is that allowing a badly malformed response
> without a clear server bug to workaround unnecessarily weakens
> our validity checking.   The better/stricter the validity checking the more
> likely we are to throw away attack frames (intentionally illegal responses
> designed to mess up the kernel).
> 

I see no problem with allowing an RFC frame up to the size of the
buffer. By the time we get to this check, we've *already* received it
into the response buffer. cifs_demultiplex_thread has this check:

                /* else we have an SMB response */
                if ((pdu_length > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) ||
                            (pdu_length < sizeof(struct smb_hdr) - 1 - 4)) {
                        cERROR(1, "Invalid size SMB length %d pdu_length %d",
                                        length, pdu_length+4);
                        cifs_reconnect(server);
                        csocket = server->ssocket;
                        wake_up(&server->response_q);
                        continue;
                }

...so we've already received it into the buffer, and we know that the
RFC length fits within the buffer, and we've checked that the
calculated SMB length fits within the RFC length.

So what's the purpose of only allowing an RFC frame that's 512 bytes
bigger than the SMB? It's certainly inefficient for the server to send
us such a frame, but it's not really harmful and I see no need to
reject it for that reason alone.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
