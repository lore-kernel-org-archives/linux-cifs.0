From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: re: cifs: sanitize username handling
Date: Mon, 19 May 2014 23:33:33 +0300
Message-ID: <20140519203333.GA5671@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Jeff Layton,

The patch 04febabcf55b: "cifs: sanitize username handling" from Jan
17, 2012, leads to the following static checker warning:

	fs/cifs/connect.c:2231 match_session()
	error: we previously assumed 'vol->username' could be null (see line 2228)

fs/cifs/connect.c
  2219                  /* NULL username means anonymous session */
  2220                  if (ses->user_name == NULL) {
  2221                          if (!vol->nullauth)
  2222                                  return 0;
  2223                          break;
  2224                  }
  2225  
  2226                  /* anything else takes username/password */
  2227                  if (strncmp(ses->user_name,
  2228                              vol->username ? vol->username : "",
                                    ^^^^^^^^^^^^^
We added this check for vol->username here.

  2229                              CIFS_MAX_USERNAME_LEN))
  2230                          return 0;
  2231                  if (strlen(vol->username) != 0 &&
                                   ^^^^^^^^^^^^^
But this dereference is not checked.

  2232                      ses->password != NULL &&
  2233                      strncmp(ses->password,
  2234                              vol->password ? vol->password : "",
  2235                              CIFS_MAX_PASSWORD_LEN))
  2236                          return 0;

regards,
dan carpenter
