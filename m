From: Ray Van Dolson <rvandolson-v48TKWNzwFw@public.gmane.org>
Subject: Watching for changes to a CIFS directory
Date: Fri, 14 Oct 2011 16:48:17 -0700
Message-ID: <20111014234816.GA14503@esri.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I'd like to watch a CIFS mounted directory for changes (files being
created in specific).

Does the CIFS client have working support for either INOTIFY or
DNOTIFY?  From perusing the mailing list, it seems that INOTIFY support
is not present, but there was discussion on implementing DNOTIFY
support some time back[1].  I'm not clear if that was ever partially or
fully implemented.

My current test scripts are using DNOTIFY and are not working with the
CIFS client included in RHEL5, Fedora 13 or Fedora 14.

Thanks,
Ray

[1] http://lists.samba.org/archive/linux-cifs-client/2009-January/003946.html
