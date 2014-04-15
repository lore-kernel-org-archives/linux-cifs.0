From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH] cif: fix dead code
Date: Tue, 15 Apr 2014 09:16:12 +0100
Message-ID: <20140415081612.GV18016@ZenIV.linux.org.uk>
References: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Opdenacker <michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1397549210-29445-1-git-send-email-michael.opdenacker-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 15, 2014 at 10:06:50AM +0200, Michael Opdenacker wrote:
> This issue was found by Coverity (CID 1202536)
> 
> This proposes a fix for a statement that creates dead code.
> The "rc < 0" statement is within code that is run
> with "rc > 0".
> 
> It seems like "err < 0" was meant to be used here.
> This way, the error code is returned by the function.

Acked-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
