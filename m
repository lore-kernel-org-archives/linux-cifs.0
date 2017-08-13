From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [[PATCH v1] 16/37] [CIFS] SMBD: Post a SMBD message with no
 payload
Date: Sun, 13 Aug 2017 03:24:12 -0700
Message-ID: <20170813102412.GH17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-17-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-17-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 02, 2017 at 01:10:27PM -0700, Long Li wrote:
> From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> 
> Implement the function to send a SMBD message with no payload. This is required at times when we want to extend credtis to server to have it continue to send data, without sending any actual data payload.

Shouldn't this just be implemented as a special case in the version
that posts data?
