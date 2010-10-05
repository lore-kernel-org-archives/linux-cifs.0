From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/14] cifs: clean up management of open filehandles
Date: Tue, 05 Oct 2010 16:00:19 +0530
Message-ID: <4CAAFE3B.6080707@suse.de>
References: <1286214781-626-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286214781-626-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/04/2010 11:22 PM, Jeff Layton wrote:
> This patchset fixes a number of problems with the existing CIFS code. It
> eliminates the backreference to the filp from cifsFileInfo, allowing a
> cifsFileInfo to outlive the filp that it was generated against.
> 
> With that change, most of the closing of a filehandle on the server is
> moved to cifsFileInfo_put. cifs_close is then changed to just put the
> filehandle instead of trying to wait around for existing users to
> finish with it.
> 
> With this change, there is some further cleanup that can be done as
> well. For instance, there's no real need to continually search for new
> filehandles in cifs_writepages now that we hold a reference to one. I'll
> hold back on that until I know how this set has been received.
> 

Nice cleanups. Patches 1 to 9 looks correct to me.


Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
