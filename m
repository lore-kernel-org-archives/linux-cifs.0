From: Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: call strtobool instead of custom implementation
Date: Mon, 12 May 2014 16:22:03 +0300
Message-ID: <20140512132203.GA31367@leiri.espoo.7ia.org>
References: <1398783193-13741-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20140512044114.GA19939@leiri.espoo.7ia.org>
 <20140512064100.5ba419a8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140512064100.5ba419a8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 12, 2014 at 06:41:00AM -0400, Jeff Layton wrote:
> > This changes the returned value of cifs_linux_ext_proc_write() to
> > -EINVAL if strtobool() was not able to find a boolean value.
> > Previously setting anything non-bool wouldn't cause this side-effect.
> > 
> > Steve, is it OK to you? This is certainly a visible change in that
> > writing to a proc entry will cause user-space error where it was
> > ignored before.
> > 
> 
> I think returning an error there is the right thing to do. If someone
> is writing to this file, they likely mean for it to have some sort of
> an effect.
> 
> Honestly though, the *best* thing would be to (gradually) convert these
> procfile switches into module options. The way it stands now, it's
> really hard to set these at boot time. You have to:
> 
>     # modprobe cifs
>     # echo N > /proc/fs/cifs/LinuxExtensionsEnabled
>     # mount -t cifs ...
> 
> Making sure that gets done for anything in /etc/fstab is...tricky.
> 
> What would be best is to add module options that affect these
> variables that could be set via /etc/modprobe.d.
> 
> Then, either add a warning printk when someone writes to these files
> that they'll soon be deprecated (in 2-3 releases), or maybe turn them
> into symlinks that point to the files under /sys/module/cifs/parameters.
I agree.

I think strtobool() patches are fine (+ change to the commit message).
The change to module options should certainly be done in a separate
patchset.

-- 
/ Alexander Bokovoy
